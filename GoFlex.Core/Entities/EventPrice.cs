﻿namespace GoFlex.Core.Entities
{
    public class EventPrice : Entity<int>
    {
        public string Name { get; set; }
        public decimal Price { get; set; }
        public int Total { get; set; }

        public int EventId { get; set; }

        public virtual Event Event { get; set; }

        public string FormattedPrice => $"{Price:N} BYN";
    }
}
