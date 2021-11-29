using System;
using System.Collections.Generic;
using System.Data.Entity.Core;
using System.Linq;
using System.Linq.Expressions;
using GoFlex.Core.Entities;
using GoFlex.Core.Repositories;

namespace GoFlex.Infrastructure.Repositories
{
    internal sealed class CommentRepository : Repository<Comment>, ICommentRepository
    {
        public CommentRepository(GoFlexContext context) : base(context)
        {
        }

        public Comment Get(Guid key) => dbSet.Find(key);

        public IEnumerable<Comment> All(params Expression<Func<Comment, bool>>[] predicates)
        {
            var query = dbSet.AsQueryable().ApplyPredicates(predicates);

            return query.ToList();
        }

        public void Insert(Comment entity)
        {
            if (entity == null)
                throw new ArgumentNullException(nameof(entity));

            dbSet.Add(entity);
        }

        public void Remove(Guid key) => dbSet.Remove(dbSet.Find(key) ?? throw new ObjectNotFoundException());
    }
}
