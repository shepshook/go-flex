using System;
using GoFlex.Core.Entities;
using GoFlex.Web.Services.Abstractions;
using MailKit.Net.Smtp;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using MimeKit;
using MimeKit.Utils;
using QRCoder;
using Serilog;

namespace GoFlex.Web.Services
{
    public class MailService : IMailService
    {
        private readonly IConfiguration _configuration;
        private readonly ILogger _logger;
        private readonly QRCodeGenerator _qrGenerator;

        public MailService(IConfiguration configuration, ILogger logger)
        {
            _configuration = configuration;
            _logger = logger;
            _qrGenerator = new QRCodeGenerator();
        }

        public void SendOrder(Order order, string requestBase, IUrlHelper url)
        {
            var message = BuildMessage(order, requestBase, url);
            try
            {
                using var client = new SmtpClient();
                client.Connect(_configuration["MailKit:SmtpServer"], int.Parse(_configuration["MailKit:Port"]), true);
                client.Authenticate(_configuration["MailKit:Email"], _configuration["MailKit:Password"]);
                client.Send(message);
                client.Disconnect(true);
            }
            catch (Exception e)
            {
                _logger.Here().Error("@{Exception}", e);
            }

            _logger.Here().Information("Mail sent to {Email}", order.User.Email);
        }

        private MimeMessage BuildMessage(Order order, string requestBase, IUrlHelper url)
        {
            var message = new MimeMessage
            {
                Subject = "Your order from GoFlex"
            };

            message.From.Add(new MailboxAddress("GoFlex", _configuration["MailKit:Email"]));
            message.To.Add(new MailboxAddress(order.User.Email, order.User.Email));

            var builder = new BodyBuilder();
            foreach (var item in order.Items)
            {
                foreach (var secret in item.Secrets)
                {
                    var image = builder.LinkedResources.Add($"{item.EventPrice.Name}",
                        GetQrCodeBytes(requestBase + url.Action("ConfirmTicket", "Organizer", new {id = secret.Id})));

                    image.ContentId = MimeUtils.GenerateMessageId();

                    builder.HtmlBody += GetTicketHtml(item.EventPrice, image.ContentId);
                }
            }

            message.Body = builder.ToMessageBody();

            return message;
        }

        private byte[] GetQrCodeBytes(string url)
        {
            var payload = new PayloadGenerator.Url(url);
            var qrCode = new BitmapByteQRCode(_qrGenerator.CreateQrCode(payload));
            var bytes = qrCode.GetGraphic(3);

            return bytes;
        }

        private string GetTicketHtml(EventPrice item, string imageId)
        {
            return $"<hr/>" +
                   $"<table>" +
                   $"   <tr>" +
                   $"       <td style=\"width: 70%\"><h2>{item.Event.Name} - {item.Name}</h2></td>" +
                   $"       <td rowspan=\"3\"><img src=\"cid:{imageId}\"/></td>" +
                   $"   </tr>" +
                   $"   <tr><td><h4>At: {item.Event.Location.Name}</h5></td></tr>" +
                   $"   <tr><td><h4>On: {item.Event.ShortDateTime}</h4></td></tr>" +
                   $"</table>" +
                   $"<hr/>";
        }
    }
}
