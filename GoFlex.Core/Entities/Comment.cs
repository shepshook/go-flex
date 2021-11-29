using System;
using System.Collections.Generic;

namespace GoFlex.Core.Entities
{
    public class Comment : Entity<Guid>
    {
        public Guid? ParentId { get; set; }

        public int? EventId { get; set; }

        public Guid UserId { get; set; }

        public string Text { get; set; }


        public virtual Event Event { get; set; }

        public virtual Comment Parent { get; set; }

        public virtual IList<Comment> Children { get; set; }
    }
}