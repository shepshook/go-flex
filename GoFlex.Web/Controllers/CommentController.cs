using System;
using GoFlex.Core.Entities;
using GoFlex.Core.Repositories.Abstractions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace GoFlex.Web.Controllers
{
    [Authorize]
    public class CommentController : Controller
    {
        private readonly IUnitOfWork _unitOfWork;

        public CommentController(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        [HttpPost("[controller]/[action]")]
        public ActionResult PostComment(Comment comment)
        {
            comment.UserId = Guid.Parse(User.FindFirst("userId").Value);
            comment.Id = Guid.NewGuid();

            _unitOfWork.CommentRepository.Insert(comment);
            _unitOfWork.Commit();

            return Ok();
        }
    }
}