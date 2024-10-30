using Microsoft.EntityFrameworkCore;

namespace BookExchangeAPI.Models
{
    public class BookExchangeDbContext : DbContext
    {
        public BookExchangeDbContext(DbContextOptions<BookExchangeDbContext> options)
            : base(options)
        {
        }

        public DbSet<User> Users { get; set; }
        public DbSet<Book> Books { get; set; }
        public DbSet<ExchangeRequest> ExchangeRequests { get; set; }
        public DbSet<Message> Messages { get; set; }
        public DbSet<TransactionHistory> TransactionHistories { get; set; }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<User>(entity =>
            {
                entity.ToTable("users");
                entity.HasKey(e => e.UserId);
                entity.Property(e => e.UserId).HasColumnName("user_id").ValueGeneratedOnAdd();
                entity.Property(e => e.Role).HasColumnName("user_role");
                entity.Property(e => e.FullName).HasColumnName("user_full_name").IsRequired();
                entity.Property(e => e.Email).HasColumnName("user_email").IsRequired();
                entity.Property(e => e.Password).HasColumnName("user_password").IsRequired();
                entity.Property(e => e.Preferences).HasColumnName("user_preferences");
                entity.Property(e => e.Address).HasColumnName("user_address");
                entity.Property(e => e.Bio).HasColumnName("bio"); 
                entity.Property(e => e.FavoriteGenres).HasColumnName("favorite_genres");
                entity.Property(e => e.LastUpdatedDatetime).HasColumnName("user_last_updated_datetime");
                entity.Property(e => e.CreationDatetime).HasColumnName("user_creation_datetime");
            });

            modelBuilder.Entity<Book>(entity =>
            {
                entity.ToTable("books");
                entity.HasKey(e => e.BookId);
                entity.Property(e => e.BookId).HasColumnName("book_id").ValueGeneratedOnAdd();
                entity.Property(e => e.Title).HasColumnName("book_title");
                entity.Property(e => e.Author).HasColumnName("book_author");
                entity.Property(e => e.Genre).HasColumnName("book_genre");
                entity.Property(e => e.Condition).HasColumnName("book_condition");
                entity.Property(e => e.AvailabilityStatus).HasColumnName("book_availability_status");
                entity.Property(e => e.UserId).HasColumnName("book_user_id");
                entity.Property(e => e.LastUpdatedDatetime).HasColumnName("book_last_updated_datetime");
                entity.Property(e => e.CreationDatetime).HasColumnName("book_creation_datetime");

                entity.HasOne(b => b.User)
                    .WithMany()
                    .HasForeignKey(b => b.UserId)
                    .OnDelete(DeleteBehavior.Cascade);
            });

            modelBuilder.Entity<ExchangeRequest>(entity =>
            {
                entity.ToTable("exchange_requests");
                entity.HasKey(e => e.ExchangeRequestId);
                entity.Property(e => e.ExchangeRequestId).HasColumnName("exchange_request_id").ValueGeneratedOnAdd();
                entity.Property(e => e.SenderId).HasColumnName("exchange_request_sender_id");
                entity.Property(e => e.ReceiverId).HasColumnName("exchange_request_receiver_id");
                entity.Property(e => e.BookId).HasColumnName("exchange_request_book_id");
                entity.Property(e => e.Status).HasColumnName("exchange_request_status");
                entity.Property(e => e.NegotiationDetails).HasColumnName("exchange_request_negotiation_details");
                entity.Property(e => e.LastUpdatedDatetime).HasColumnName("exchange_request_last_updated_datetime");
                entity.Property(e => e.CreationDatetime).HasColumnName("exchange_request_creation_datetime");

                entity.HasOne(er => er.Book)
                    .WithMany()
                    .HasForeignKey(er => er.BookId)
                    .OnDelete(DeleteBehavior.Cascade);
            });

            modelBuilder.Entity<Message>(entity =>
            {
                entity.ToTable("messages");
                entity.HasKey(e => e.MessageId);
                entity.Property(e => e.MessageId).HasColumnName("message_id").ValueGeneratedOnAdd();
                entity.Property(e => e.SenderId).HasColumnName("message_sender_id");
                entity.Property(e => e.ReceiverId).HasColumnName("message_receiver_id");
                entity.Property(e => e.ExchangeRequestId).HasColumnName("message_exchange_request_id");
                entity.Property(e => e.Text).HasColumnName("message_text");
                entity.Property(e => e.SendDatetime).HasColumnName("message_send_datetime");

                entity.HasOne(m => m.ExchangeRequest)
                    .WithMany()
                    .HasForeignKey(m => m.ExchangeRequestId)
                    .OnDelete(DeleteBehavior.Cascade);
            });

            modelBuilder.Entity<TransactionHistory>(entity =>
            {
                entity.ToTable("transaction_history");
                entity.HasKey(e => e.TransactionId);
                entity.Property(e => e.TransactionId).HasColumnName("transaction_id").ValueGeneratedOnAdd();
                entity.Property(e => e.ExchangeRequestId).HasColumnName("transaction_exchange_request_id");
                entity.Property(e => e.Status).HasColumnName("transaction_status");
                entity.Property(e => e.LastUpdatedDatetime).HasColumnName("transaction_last_updated_datetime");
                entity.Property(e => e.CreationDatetime).HasColumnName("transaction_creation_datetime");

                entity.HasOne(th => th.ExchangeRequest)
                    .WithMany()
                    .HasForeignKey(th => th.ExchangeRequestId)
                    .OnDelete(DeleteBehavior.Cascade);
            });
            base.OnModelCreating(modelBuilder);
        }
    }
}
