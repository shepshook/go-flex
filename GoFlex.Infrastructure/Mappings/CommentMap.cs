using System.Data.Entity.ModelConfiguration;
using GoFlex.Core.Entities;

namespace GoFlex.Infrastructure.Mappings
{
    public class CommentMap : EntityTypeConfiguration<Comment>
    {
        public CommentMap()
        {
            ToTable("Comment");

            HasKey(x => x.Id);
            Property(x => x.Id).HasColumnName("CommentId");

            Property(x => x.Text).IsRequired();
            
            HasMany(x => x.Children).WithOptional(child => child.Parent).HasForeignKey(child => child.ParentId);
            HasOptional(x => x.Event).WithMany(e => e.RootComments).HasForeignKey(comment => comment.EventId);
        }
    }
}
