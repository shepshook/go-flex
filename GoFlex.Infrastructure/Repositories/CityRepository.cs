using System;
using System.Collections.Generic;
using System.Data.Entity.Core;
using System.Linq;
using System.Linq.Expressions;
using GoFlex.Core.Entities;
using GoFlex.Core.Repositories;

namespace GoFlex.Infrastructure.Repositories
{
    internal sealed class CityRepository : Repository<City>, ICityRepository
    {
        public CityRepository(GoFlexContext context) : base(context)
        {
        }

        public City Get(int key) => dbSet.Find(key);

        public IEnumerable<City> All(params Expression<Func<City, bool>>[] predicates)
        {
            var query = dbSet.AsQueryable().ApplyPredicates(predicates);

            return query.ToList();
        }

        public void Insert(City entity)
        {
            if (entity == null)
                throw new ArgumentNullException(nameof(entity));

            dbSet.Add(entity);
        }

        public void Remove(int key) => dbSet.Remove(dbSet.Find(key) ?? throw new ObjectNotFoundException());
    }
}
