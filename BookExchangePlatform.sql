USE [master]
GO
/****** Object:  Database [BookExchangeDB]    Script Date: 17-11-2024 03:49:21 ******/
CREATE DATABASE [BookExchangeDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BookExchangeDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\BookExchangeDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'BookExchangeDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\BookExchangeDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [BookExchangeDB] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BookExchangeDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BookExchangeDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BookExchangeDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BookExchangeDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BookExchangeDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BookExchangeDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [BookExchangeDB] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [BookExchangeDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BookExchangeDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BookExchangeDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BookExchangeDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BookExchangeDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BookExchangeDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BookExchangeDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BookExchangeDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BookExchangeDB] SET  ENABLE_BROKER 
GO
ALTER DATABASE [BookExchangeDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BookExchangeDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BookExchangeDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BookExchangeDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BookExchangeDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BookExchangeDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BookExchangeDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BookExchangeDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [BookExchangeDB] SET  MULTI_USER 
GO
ALTER DATABASE [BookExchangeDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BookExchangeDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BookExchangeDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BookExchangeDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [BookExchangeDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [BookExchangeDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [BookExchangeDB] SET QUERY_STORE = OFF
GO
USE [BookExchangeDB]
GO
/****** Object:  Table [dbo].[books]    Script Date: 17-11-2024 03:49:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[books](
	[book_id] [int] IDENTITY(1001,1) NOT NULL,
	[book_title] [varchar](255) NOT NULL,
	[book_author] [varchar](255) NOT NULL,
	[book_genre] [varchar](100) NULL,
	[book_condition] [varchar](50) NULL,
	[book_availability_status] [bit] NULL,
	[book_user_id] [int] NOT NULL,
	[book_last_updated_datetime] [datetime] NULL,
	[book_creation_datetime] [datetime] NULL,
 CONSTRAINT [PK_books] PRIMARY KEY CLUSTERED 
(
	[book_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[exchange_requests]    Script Date: 17-11-2024 03:49:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[exchange_requests](
	[exchange_request_id] [int] IDENTITY(11001,1) NOT NULL,
	[exchange_request_sender_id] [int] NOT NULL,
	[exchange_request_receiver_id] [int] NOT NULL,
	[exchange_request_book_id] [int] NOT NULL,
	[exchange_request_status] [varchar](50) NULL,
	[exchange_request_negotiation_details] [varchar](255) NULL,
	[exchange_request_last_updated_datetime] [datetime] NULL,
	[exchange_request_creation_datetime] [datetime] NULL,
 CONSTRAINT [PK_exchange_requests] PRIMARY KEY CLUSTERED 
(
	[exchange_request_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[messages]    Script Date: 17-11-2024 03:49:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[messages](
	[message_id] [int] IDENTITY(21001,1) NOT NULL,
	[message_sender_id] [int] NOT NULL,
	[message_receiver_id] [int] NOT NULL,
	[message_exchange_request_id] [int] NOT NULL,
	[message_text] [varchar](500) NOT NULL,
	[message_send_datetime] [datetime] NULL,
 CONSTRAINT [PK_messages] PRIMARY KEY CLUSTERED 
(
	[message_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[transaction_history]    Script Date: 17-11-2024 03:49:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[transaction_history](
	[transaction_id] [int] IDENTITY(31001,1) NOT NULL,
	[transaction_exchange_request_id] [int] NOT NULL,
	[transaction_status] [varchar](50) NOT NULL,
	[transaction_last_updated_datetime] [datetime] NULL,
	[transaction_creation_datetime] [datetime] NULL,
 CONSTRAINT [PK_transaction_history] PRIMARY KEY CLUSTERED 
(
	[transaction_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[users]    Script Date: 17-11-2024 03:49:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[users](
	[user_id] [int] IDENTITY(701001,1) NOT NULL,
	[user_role] [varchar](10) NULL,
	[user_full_name] [varchar](100) NOT NULL,
	[user_email] [varchar](100) NOT NULL,
	[user_password] [varchar](255) NOT NULL,
	[user_preferences] [varchar](255) NULL,
	[user_address] [varchar](255) NULL,
	[bio] [varchar](255) NULL,
	[favorite_genres] [varchar](255) NULL,
	[user_last_updated_datetime] [datetime] NULL,
	[user_creation_datetime] [datetime] NULL,
 CONSTRAINT [PK_users] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[books] ON 

INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1001, N'My Life', N'Bharathiyar', N'Biography', N'New', 0, 701001, CAST(N'2024-11-15T12:16:44.713' AS DateTime), CAST(N'2024-10-23T16:11:18.067' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1002, N'The River Kannan', N'Bharathiyar', N'Poetry', N'Good', 0, 701002, CAST(N'2024-11-15T12:06:24.387' AS DateTime), CAST(N'2024-10-23T16:11:18.067' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1003, N'The Story of Earth', N'Veeramamani', N'Fiction', N'Used', 1, 701003, CAST(N'2024-10-23T16:11:18.067' AS DateTime), CAST(N'2024-10-23T16:11:18.067' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1004, N'Songs', N'Kannadasan', N'Poetry', N'New', 1, 701004, CAST(N'2024-10-23T16:11:18.067' AS DateTime), CAST(N'2024-10-23T16:11:18.067' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1005, N'Flower of Karikuppu', N'Ashokamithran', N'Fiction', N'Good', 1, 701005, CAST(N'2024-10-23T16:11:18.067' AS DateTime), CAST(N'2024-10-23T16:11:18.067' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1006, N'People’s Assembly', N'Soviyaraja', N'Non-Fiction', N'Used', 1, 701006, CAST(N'2024-10-23T16:11:18.067' AS DateTime), CAST(N'2024-10-23T16:11:18.067' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1007, N'Manmathan', N'Kalika', N'Drama', N'New', 1, 701007, CAST(N'2024-10-23T16:11:18.067' AS DateTime), CAST(N'2024-10-23T16:11:18.067' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1008, N'Sethan’s Thoughts', N'Padmanaban', N'Philosophy', N'Good', 1, 701008, CAST(N'2024-10-23T16:11:18.067' AS DateTime), CAST(N'2024-10-23T16:11:18.067' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1009, N'Friends', N'Jayakannan', N'Fiction', N'Used', 1, 701009, CAST(N'2024-10-23T16:11:18.067' AS DateTime), CAST(N'2024-10-23T16:11:18.067' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1010, N'The Storytelling Tamil', N'Muyalin', N'Fiction', N'New', 1, 701010, CAST(N'2024-10-23T16:11:18.067' AS DateTime), CAST(N'2024-10-23T16:11:18.067' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1011, N'Creations', N'Kumaran', N'Fantasy', N'Good', 0, 701001, CAST(N'2024-10-24T19:37:22.477' AS DateTime), CAST(N'2024-10-23T16:11:18.067' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1012, N'The King’s Hero', N'Madhavan', N'Fiction', N'New', 1, 701002, CAST(N'2024-10-23T16:11:18.067' AS DateTime), CAST(N'2024-10-23T16:11:18.067' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1013, N'Human', N'Arun', N'Fiction', N'Used', 1, 701003, CAST(N'2024-10-23T16:11:18.067' AS DateTime), CAST(N'2024-10-23T16:11:18.067' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1014, N'Scientific Journey', N'Solvadhu', N'Science', N'Good', 1, 701004, CAST(N'2024-10-23T16:11:18.067' AS DateTime), CAST(N'2024-10-23T16:11:18.067' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1015, N'Tamil Ethnicity', N'Madhivaan', N'Culture', N'New', 1, 701005, CAST(N'2024-10-23T16:11:18.067' AS DateTime), CAST(N'2024-10-23T16:11:18.067' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1016, N'Freedom Fighters', N'Nandhakumar', N'Biography', N'Good', 1, 701006, CAST(N'2024-10-23T16:11:18.067' AS DateTime), CAST(N'2024-10-23T16:11:18.067' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1017, N'Tamil Fundamentals', N'Gopal', N'Education', N'Used', 1, 701007, CAST(N'2024-10-23T16:11:18.067' AS DateTime), CAST(N'2024-10-23T16:11:18.067' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1018, N'Building Structures', N'Viduthalai', N'Non-Fiction', N'New', 1, 701008, CAST(N'2024-10-23T16:11:18.067' AS DateTime), CAST(N'2024-10-23T16:11:18.067' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1019, N'Website', N'Gopalakrishnan', N'Technology', N'Good', 1, 701009, CAST(N'2024-10-23T16:11:18.067' AS DateTime), CAST(N'2024-10-23T16:11:18.067' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1020, N'Genetics Lessons', N'Pandiyan', N'Science', N'Used', 1, 701010, CAST(N'2024-10-23T16:11:18.067' AS DateTime), CAST(N'2024-10-23T16:11:18.067' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1021, N'The Alchemist', N'Paulo Coelho', N'Fiction', N'New', 1, 701001, CAST(N'2024-11-15T12:16:10.827' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1022, N'The Great Gatsby', N'F. Scott Fitzgerald', N'Fiction', N'Like New', 1, 701002, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1023, N'To Kill a Mockingbird', N'Harper Lee', N'Fiction', N'Good', 1, 701003, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1024, N'1984', N'George Orwell', N'Science Fiction', N'New', 1, 701004, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1025, N'Pride and Prejudice', N'Jane Austen', N'Romance', N'Good', 1, 701005, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1026, N'The Catcher in the Rye', N'J.D. Salinger', N'Fiction', N'Like New', 1, 701006, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1027, N'Siddhartha', N'Hermann Hesse', N'Fiction', N'Good', 1, 701007, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1028, N'Wings of Fire', N'A.P.J. Abdul Kalam', N'Biography', N'New', 1, 701008, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1029, N'The God of Small Things', N'Arundhati Roy', N'Fiction', N'Like New', 1, 701009, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1030, N'Life of Pi', N'Yann Martel', N'Fiction', N'Good', 1, 701010, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1031, N'The Secret', N'Rhonda Byrne', N'Self-Help', N'New', 1, 701001, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1032, N'The Power of Now', N'Eckhart Tolle', N'Self-Help', N'Good', 1, 701002, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1033, N'Sapiens: A Brief History of Humankind', N'Yuval Noah Harari', N'Non-Fiction', N'Like New', 1, 701003, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1034, N'Becoming', N'Michelle Obama', N'Biography', N'New', 1, 701004, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1035, N'The Immortal Life of Henrietta Lacks', N'Rebecca Skloot', N'Non-Fiction', N'Good', 1, 701005, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1036, N'The Diary of a Young Girl', N'Anne Frank', N'Biography', N'Like New', 1, 701006, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1037, N'Rich Dad Poor Dad', N'Robert Kiyosaki', N'Self-Help', N'New', 1, 701007, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1038, N'The Subtle Art of Not Giving a F*ck', N'Mark Manson', N'Self-Help', N'Good', 1, 701008, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1039, N'The Fault in Our Stars', N'John Green', N'Fiction', N'Like New', 1, 701009, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1040, N'The Shining', N'Stephen King', N'Horror', N'New', 1, 701010, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1041, N'The Hobbit', N'J.R.R. Tolkien', N'Fantasy', N'Good', 1, 701001, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1042, N'The Chronicles of Narnia', N'C.S. Lewis', N'Fantasy', N'Like New', 1, 701002, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1043, N'Murder on the Orient Express', N'Agatha Christie', N'Mystery', N'New', 1, 701003, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1044, N'And Then There Were None', N'Agatha Christie', N'Mystery', N'Good', 1, 701004, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1045, N'The Da Vinci Code', N'Dan Brown', N'Mystery', N'Like New', 1, 701005, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1046, N'Inferno', N'Dan Brown', N'Mystery', N'New', 1, 701006, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1047, N'Atomic Habits', N'James Clear', N'Self-Help', N'Good', 1, 701007, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1048, N'Educated', N'Tara Westover', N'Biography', N'Like New', 1, 701008, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1049, N'Where the Crawdads Sing', N'Delia Owens', N'Fiction', N'New', 1, 701009, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1050, N'The Girl with the Dragon Tattoo', N'Stalker', N'Mystery', N'Good', 1, 701010, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1052, N'The Kite Runner', N'Khaled Hosseini', N'Fiction', N'Good', 1, 701002, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1053, N'Girl, Woman, Other', N'Bernardine Evaristo', N'Fiction', N'New', 1, 701003, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1054, N'Americanah', N'Chimamanda Ngozi Adichie', N'Fiction', N'Good', 1, 701004, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1055, N'One Hundred Years of Solitude', N'Gabriel Garcia Marquez', N'Fiction', N'Like New', 1, 701005, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1056, N'The Hitchhiker’s Guide to the Galaxy', N'Douglas Adams', N'Science Fiction', N'New', 1, 701006, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1057, N'Fahrenheit 451', N'Ray Bradbury', N'Science Fiction', N'Good', 1, 701007, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1058, N'Brave New World', N'Aldous Huxley', N'Science Fiction', N'Like New', 1, 701008, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1059, N'The Road', N'Cormac McCarthy', N'Science Fiction', N'Good', 1, 701009, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1060, N'Dune', N'Frank Herbert', N'Science Fiction', N'New', 1, 701010, CAST(N'2024-10-23T16:18:07.380' AS DateTime), CAST(N'2024-10-23T16:18:07.380' AS DateTime))
INSERT [dbo].[books] ([book_id], [book_title], [book_author], [book_genre], [book_condition], [book_availability_status], [book_user_id], [book_last_updated_datetime], [book_creation_datetime]) VALUES (1062, N'Ponniyin Selvan', N'Kalki Krishnamurthy', N'Historical Fiction', N'Like New', 0, 701011, CAST(N'2024-11-15T12:20:35.720' AS DateTime), CAST(N'2024-11-15T12:11:14.363' AS DateTime))
SET IDENTITY_INSERT [dbo].[books] OFF
GO
SET IDENTITY_INSERT [dbo].[exchange_requests] ON 

INSERT [dbo].[exchange_requests] ([exchange_request_id], [exchange_request_sender_id], [exchange_request_receiver_id], [exchange_request_book_id], [exchange_request_status], [exchange_request_negotiation_details], [exchange_request_last_updated_datetime], [exchange_request_creation_datetime]) VALUES (11001, 701002, 701001, 1001, N'Accepted', N'Looking forward to the exchange!', CAST(N'2024-11-15T12:16:44.677' AS DateTime), CAST(N'2024-10-23T16:11:18.080' AS DateTime))
INSERT [dbo].[exchange_requests] ([exchange_request_id], [exchange_request_sender_id], [exchange_request_receiver_id], [exchange_request_book_id], [exchange_request_status], [exchange_request_negotiation_details], [exchange_request_last_updated_datetime], [exchange_request_creation_datetime]) VALUES (11002, 701003, 701002, 1002, N'Pending', N'Can we meet tomorrow?', CAST(N'2024-10-25T16:49:50.743' AS DateTime), CAST(N'2024-10-23T16:11:18.080' AS DateTime))
INSERT [dbo].[exchange_requests] ([exchange_request_id], [exchange_request_sender_id], [exchange_request_receiver_id], [exchange_request_book_id], [exchange_request_status], [exchange_request_negotiation_details], [exchange_request_last_updated_datetime], [exchange_request_creation_datetime]) VALUES (11003, 701004, 701003, 1003, N'Completed', N'Exchanged successfully at the coffee shop.', CAST(N'2024-10-23T16:11:18.080' AS DateTime), CAST(N'2024-10-23T16:11:18.080' AS DateTime))
INSERT [dbo].[exchange_requests] ([exchange_request_id], [exchange_request_sender_id], [exchange_request_receiver_id], [exchange_request_book_id], [exchange_request_status], [exchange_request_negotiation_details], [exchange_request_last_updated_datetime], [exchange_request_creation_datetime]) VALUES (11004, 701005, 701004, 1004, N'Rejected', N'Sorry, I changed my mind.', CAST(N'2024-10-23T16:11:18.080' AS DateTime), CAST(N'2024-10-23T16:11:18.080' AS DateTime))
INSERT [dbo].[exchange_requests] ([exchange_request_id], [exchange_request_sender_id], [exchange_request_receiver_id], [exchange_request_book_id], [exchange_request_status], [exchange_request_negotiation_details], [exchange_request_last_updated_datetime], [exchange_request_creation_datetime]) VALUES (11006, 701007, 701006, 1006, N'Accepted', N'Let’s finalize the details.', CAST(N'2024-10-23T16:11:18.080' AS DateTime), CAST(N'2024-10-23T16:11:18.080' AS DateTime))
INSERT [dbo].[exchange_requests] ([exchange_request_id], [exchange_request_sender_id], [exchange_request_receiver_id], [exchange_request_book_id], [exchange_request_status], [exchange_request_negotiation_details], [exchange_request_last_updated_datetime], [exchange_request_creation_datetime]) VALUES (11007, 701008, 701007, 1007, N'Pending', N'I am interested in this book.', CAST(N'2024-10-23T16:11:18.080' AS DateTime), CAST(N'2024-10-23T16:11:18.080' AS DateTime))
INSERT [dbo].[exchange_requests] ([exchange_request_id], [exchange_request_sender_id], [exchange_request_receiver_id], [exchange_request_book_id], [exchange_request_status], [exchange_request_negotiation_details], [exchange_request_last_updated_datetime], [exchange_request_creation_datetime]) VALUES (11008, 701009, 701008, 1008, N'Accepted', N'I will take good care of it.', CAST(N'2024-10-23T16:11:18.080' AS DateTime), CAST(N'2024-10-23T16:11:18.080' AS DateTime))
INSERT [dbo].[exchange_requests] ([exchange_request_id], [exchange_request_sender_id], [exchange_request_receiver_id], [exchange_request_book_id], [exchange_request_status], [exchange_request_negotiation_details], [exchange_request_last_updated_datetime], [exchange_request_creation_datetime]) VALUES (11009, 701010, 701009, 1009, N'Rejected', N'Not my type of book.', CAST(N'2024-10-23T16:11:18.080' AS DateTime), CAST(N'2024-10-23T16:11:18.080' AS DateTime))
INSERT [dbo].[exchange_requests] ([exchange_request_id], [exchange_request_sender_id], [exchange_request_receiver_id], [exchange_request_book_id], [exchange_request_status], [exchange_request_negotiation_details], [exchange_request_last_updated_datetime], [exchange_request_creation_datetime]) VALUES (11010, 701002, 701010, 1010, N'Pending', N'Can we negotiate?', CAST(N'2024-10-25T16:49:47.513' AS DateTime), CAST(N'2024-10-23T16:11:18.080' AS DateTime))
INSERT [dbo].[exchange_requests] ([exchange_request_id], [exchange_request_sender_id], [exchange_request_receiver_id], [exchange_request_book_id], [exchange_request_status], [exchange_request_negotiation_details], [exchange_request_last_updated_datetime], [exchange_request_creation_datetime]) VALUES (11032, 701001, 701002, 1002, N'Pending', N'bhj', CAST(N'2024-10-25T16:47:47.393' AS DateTime), CAST(N'2024-10-23T21:37:38.607' AS DateTime))
INSERT [dbo].[exchange_requests] ([exchange_request_id], [exchange_request_sender_id], [exchange_request_receiver_id], [exchange_request_book_id], [exchange_request_status], [exchange_request_negotiation_details], [exchange_request_last_updated_datetime], [exchange_request_creation_datetime]) VALUES (11033, 701001, 701010, 1010, N'Pending', N'Hi', CAST(N'2024-10-25T16:46:55.250' AS DateTime), CAST(N'2024-10-23T21:49:46.840' AS DateTime))
INSERT [dbo].[exchange_requests] ([exchange_request_id], [exchange_request_sender_id], [exchange_request_receiver_id], [exchange_request_book_id], [exchange_request_status], [exchange_request_negotiation_details], [exchange_request_last_updated_datetime], [exchange_request_creation_datetime]) VALUES (11035, 701001, 701005, 1005, N'Pending', N'tvt', CAST(N'2024-10-24T13:50:05.887' AS DateTime), CAST(N'2024-10-24T13:50:05.887' AS DateTime))
INSERT [dbo].[exchange_requests] ([exchange_request_id], [exchange_request_sender_id], [exchange_request_receiver_id], [exchange_request_book_id], [exchange_request_status], [exchange_request_negotiation_details], [exchange_request_last_updated_datetime], [exchange_request_creation_datetime]) VALUES (11037, 701005, 701002, 1002, N'Pending', N'hi', CAST(N'2024-11-15T12:06:26.070' AS DateTime), CAST(N'2024-10-25T12:26:32.800' AS DateTime))
INSERT [dbo].[exchange_requests] ([exchange_request_id], [exchange_request_sender_id], [exchange_request_receiver_id], [exchange_request_book_id], [exchange_request_status], [exchange_request_negotiation_details], [exchange_request_last_updated_datetime], [exchange_request_creation_datetime]) VALUES (11038, 701011, 701002, 1002, N'Accepted', N'Hi, How are you?', CAST(N'2024-11-15T12:02:27.200' AS DateTime), CAST(N'2024-11-15T17:20:09.797' AS DateTime))
INSERT [dbo].[exchange_requests] ([exchange_request_id], [exchange_request_sender_id], [exchange_request_receiver_id], [exchange_request_book_id], [exchange_request_status], [exchange_request_negotiation_details], [exchange_request_last_updated_datetime], [exchange_request_creation_datetime]) VALUES (11039, 701001, 701011, 1062, N'Accepted', N'Hi', CAST(N'2024-11-15T12:20:35.677' AS DateTime), CAST(N'2024-11-15T17:48:31.190' AS DateTime))
SET IDENTITY_INSERT [dbo].[exchange_requests] OFF
GO
SET IDENTITY_INSERT [dbo].[messages] ON 

INSERT [dbo].[messages] ([message_id], [message_sender_id], [message_receiver_id], [message_exchange_request_id], [message_text], [message_send_datetime]) VALUES (22165, 701011, 701002, 11038, N'Hi, How are you?', CAST(N'2024-11-15T17:20:09.887' AS DateTime))
INSERT [dbo].[messages] ([message_id], [message_sender_id], [message_receiver_id], [message_exchange_request_id], [message_text], [message_send_datetime]) VALUES (22166, 701002, 701011, 11038, N'Fine, how are you?', CAST(N'2024-11-15T17:24:46.227' AS DateTime))
INSERT [dbo].[messages] ([message_id], [message_sender_id], [message_receiver_id], [message_exchange_request_id], [message_text], [message_send_datetime]) VALUES (22167, 701011, 701011, 11038, N'I''m great, I''m Interested in your book, can you give it to me for 10 days?', CAST(N'2024-11-15T17:26:07.993' AS DateTime))
INSERT [dbo].[messages] ([message_id], [message_sender_id], [message_receiver_id], [message_exchange_request_id], [message_text], [message_send_datetime]) VALUES (22168, 701002, 701011, 11038, N'Yes, ok I''m ready to give it.', CAST(N'2024-11-15T17:27:39.353' AS DateTime))
INSERT [dbo].[messages] ([message_id], [message_sender_id], [message_receiver_id], [message_exchange_request_id], [message_text], [message_send_datetime]) VALUES (22169, 701011, 701011, 11038, N'Thanks! Where can I collect the book?', CAST(N'2024-11-15T17:28:19.623' AS DateTime))
INSERT [dbo].[messages] ([message_id], [message_sender_id], [message_receiver_id], [message_exchange_request_id], [message_text], [message_send_datetime]) VALUES (22170, 701002, 701011, 11038, N'10 am at Anna Nagar, Chennai. Is it ok for you?', CAST(N'2024-11-15T17:29:26.583' AS DateTime))
INSERT [dbo].[messages] ([message_id], [message_sender_id], [message_receiver_id], [message_exchange_request_id], [message_text], [message_send_datetime]) VALUES (22171, 701011, 701011, 11038, N'Yes, it is ok for me. we can meet tomorrow.', CAST(N'2024-11-15T17:30:16.463' AS DateTime))
INSERT [dbo].[messages] ([message_id], [message_sender_id], [message_receiver_id], [message_exchange_request_id], [message_text], [message_send_datetime]) VALUES (22172, 701001, 701011, 11039, N'Hi', CAST(N'2024-11-15T17:48:31.213' AS DateTime))
INSERT [dbo].[messages] ([message_id], [message_sender_id], [message_receiver_id], [message_exchange_request_id], [message_text], [message_send_datetime]) VALUES (22173, 701011, 701001, 11039, N'Hi Vignesh', CAST(N'2024-11-15T17:50:23.040' AS DateTime))
SET IDENTITY_INSERT [dbo].[messages] OFF
GO
SET IDENTITY_INSERT [dbo].[transaction_history] ON 

INSERT [dbo].[transaction_history] ([transaction_id], [transaction_exchange_request_id], [transaction_status], [transaction_last_updated_datetime], [transaction_creation_datetime]) VALUES (31001, 11001, N'Initiated', CAST(N'2024-10-23T16:11:18.107' AS DateTime), CAST(N'2024-10-23T16:11:18.107' AS DateTime))
INSERT [dbo].[transaction_history] ([transaction_id], [transaction_exchange_request_id], [transaction_status], [transaction_last_updated_datetime], [transaction_creation_datetime]) VALUES (31002, 11002, N'Initiated', CAST(N'2024-10-23T16:11:18.107' AS DateTime), CAST(N'2024-10-23T16:11:18.107' AS DateTime))
INSERT [dbo].[transaction_history] ([transaction_id], [transaction_exchange_request_id], [transaction_status], [transaction_last_updated_datetime], [transaction_creation_datetime]) VALUES (31003, 11003, N'Initiated', CAST(N'2024-10-23T16:11:18.107' AS DateTime), CAST(N'2024-10-23T16:11:18.107' AS DateTime))
INSERT [dbo].[transaction_history] ([transaction_id], [transaction_exchange_request_id], [transaction_status], [transaction_last_updated_datetime], [transaction_creation_datetime]) VALUES (31004, 11004, N'Initiated', CAST(N'2024-10-23T16:11:18.107' AS DateTime), CAST(N'2024-10-23T16:11:18.107' AS DateTime))
INSERT [dbo].[transaction_history] ([transaction_id], [transaction_exchange_request_id], [transaction_status], [transaction_last_updated_datetime], [transaction_creation_datetime]) VALUES (31006, 11006, N'Initiated', CAST(N'2024-10-23T16:11:18.107' AS DateTime), CAST(N'2024-10-23T16:11:18.107' AS DateTime))
INSERT [dbo].[transaction_history] ([transaction_id], [transaction_exchange_request_id], [transaction_status], [transaction_last_updated_datetime], [transaction_creation_datetime]) VALUES (31007, 11007, N'Initiated', CAST(N'2024-10-23T16:11:18.107' AS DateTime), CAST(N'2024-10-23T16:11:18.107' AS DateTime))
INSERT [dbo].[transaction_history] ([transaction_id], [transaction_exchange_request_id], [transaction_status], [transaction_last_updated_datetime], [transaction_creation_datetime]) VALUES (31008, 11008, N'Initiated', CAST(N'2024-10-23T16:11:18.107' AS DateTime), CAST(N'2024-10-23T16:11:18.107' AS DateTime))
INSERT [dbo].[transaction_history] ([transaction_id], [transaction_exchange_request_id], [transaction_status], [transaction_last_updated_datetime], [transaction_creation_datetime]) VALUES (31009, 11009, N'Initiated', CAST(N'2024-10-23T16:11:18.107' AS DateTime), CAST(N'2024-10-23T16:11:18.107' AS DateTime))
INSERT [dbo].[transaction_history] ([transaction_id], [transaction_exchange_request_id], [transaction_status], [transaction_last_updated_datetime], [transaction_creation_datetime]) VALUES (31010, 11010, N'Initiated', CAST(N'2024-10-23T16:11:18.107' AS DateTime), CAST(N'2024-10-23T16:11:18.107' AS DateTime))
INSERT [dbo].[transaction_history] ([transaction_id], [transaction_exchange_request_id], [transaction_status], [transaction_last_updated_datetime], [transaction_creation_datetime]) VALUES (31015, 11001, N'Initiated', NULL, CAST(N'2024-11-15T16:42:15.277' AS DateTime))
INSERT [dbo].[transaction_history] ([transaction_id], [transaction_exchange_request_id], [transaction_status], [transaction_last_updated_datetime], [transaction_creation_datetime]) VALUES (31016, 11010, N'Initiated', NULL, CAST(N'2024-11-15T16:47:45.093' AS DateTime))
INSERT [dbo].[transaction_history] ([transaction_id], [transaction_exchange_request_id], [transaction_status], [transaction_last_updated_datetime], [transaction_creation_datetime]) VALUES (31017, 11038, N'Initiated', NULL, CAST(N'2024-11-15T17:24:46.260' AS DateTime))
INSERT [dbo].[transaction_history] ([transaction_id], [transaction_exchange_request_id], [transaction_status], [transaction_last_updated_datetime], [transaction_creation_datetime]) VALUES (31018, 11038, N'Payment Initiated', NULL, CAST(N'2024-11-15T17:32:48.763' AS DateTime))
INSERT [dbo].[transaction_history] ([transaction_id], [transaction_exchange_request_id], [transaction_status], [transaction_last_updated_datetime], [transaction_creation_datetime]) VALUES (31019, 11038, N'Payment Pending', NULL, CAST(N'2024-11-15T17:33:18.503' AS DateTime))
INSERT [dbo].[transaction_history] ([transaction_id], [transaction_exchange_request_id], [transaction_status], [transaction_last_updated_datetime], [transaction_creation_datetime]) VALUES (31020, 11038, N'Payment Received', NULL, CAST(N'2024-11-15T17:33:20.883' AS DateTime))
INSERT [dbo].[transaction_history] ([transaction_id], [transaction_exchange_request_id], [transaction_status], [transaction_last_updated_datetime], [transaction_creation_datetime]) VALUES (31021, 11038, N'Shipment Initiated', NULL, CAST(N'2024-11-15T17:33:25.160' AS DateTime))
INSERT [dbo].[transaction_history] ([transaction_id], [transaction_exchange_request_id], [transaction_status], [transaction_last_updated_datetime], [transaction_creation_datetime]) VALUES (31022, 11038, N'Delivered', NULL, CAST(N'2024-11-15T17:33:43.970' AS DateTime))
INSERT [dbo].[transaction_history] ([transaction_id], [transaction_exchange_request_id], [transaction_status], [transaction_last_updated_datetime], [transaction_creation_datetime]) VALUES (31023, 11038, N'Completed', NULL, CAST(N'2024-11-15T17:34:25.557' AS DateTime))
INSERT [dbo].[transaction_history] ([transaction_id], [transaction_exchange_request_id], [transaction_status], [transaction_last_updated_datetime], [transaction_creation_datetime]) VALUES (31024, 11039, N'Initiated', NULL, CAST(N'2024-11-15T17:50:23.067' AS DateTime))
INSERT [dbo].[transaction_history] ([transaction_id], [transaction_exchange_request_id], [transaction_status], [transaction_last_updated_datetime], [transaction_creation_datetime]) VALUES (31025, 11039, N'Payment Initiated', NULL, CAST(N'2024-11-15T17:50:55.313' AS DateTime))
INSERT [dbo].[transaction_history] ([transaction_id], [transaction_exchange_request_id], [transaction_status], [transaction_last_updated_datetime], [transaction_creation_datetime]) VALUES (31026, 11039, N'Payment Pending', NULL, CAST(N'2024-11-15T17:51:03.790' AS DateTime))
INSERT [dbo].[transaction_history] ([transaction_id], [transaction_exchange_request_id], [transaction_status], [transaction_last_updated_datetime], [transaction_creation_datetime]) VALUES (31027, 11039, N'Payment Received', NULL, CAST(N'2024-11-15T17:51:19.427' AS DateTime))
INSERT [dbo].[transaction_history] ([transaction_id], [transaction_exchange_request_id], [transaction_status], [transaction_last_updated_datetime], [transaction_creation_datetime]) VALUES (31028, 11039, N'Shipment Initiated', NULL, CAST(N'2024-11-15T17:51:21.617' AS DateTime))
INSERT [dbo].[transaction_history] ([transaction_id], [transaction_exchange_request_id], [transaction_status], [transaction_last_updated_datetime], [transaction_creation_datetime]) VALUES (31029, 11039, N'Delivered', NULL, CAST(N'2024-11-15T17:51:26.230' AS DateTime))
INSERT [dbo].[transaction_history] ([transaction_id], [transaction_exchange_request_id], [transaction_status], [transaction_last_updated_datetime], [transaction_creation_datetime]) VALUES (31030, 11039, N'Completed', NULL, CAST(N'2024-11-15T17:51:28.513' AS DateTime))
SET IDENTITY_INSERT [dbo].[transaction_history] OFF
GO
SET IDENTITY_INSERT [dbo].[users] ON 

INSERT [dbo].[users] ([user_id], [user_role], [user_full_name], [user_email], [user_password], [user_preferences], [user_address], [bio], [favorite_genres], [user_last_updated_datetime], [user_creation_datetime]) VALUES (701001, N'Admin', N'Vignesh S R', N'vignesh@gmail.com', N'h3bxCOJHqx4rMjBCwEnCZkB8gfutQb3h6N/Bu2b9Jn4=', N'Fiction, History', N'1, Anna Nagar, Chennai, Tamil Nadu - 600040', N'Passionate about Tamil literature.', N'Fiction, History', CAST(N'2024-10-23T16:11:18.043' AS DateTime), CAST(N'2024-10-23T16:11:18.043' AS DateTime))
INSERT [dbo].[users] ([user_id], [user_role], [user_full_name], [user_email], [user_password], [user_preferences], [user_address], [bio], [favorite_genres], [user_last_updated_datetime], [user_creation_datetime]) VALUES (701002, N'User', N'Balachandar A', N'bala@gmail.com', N'h3bxCOJHqx4rMjBCwEnCZkB8gfutQb3h6N/Bu2b9Jn4=', N'Mystery, Thriller', N'25, T Nagar, Chennai, Tamil Nadu - 600017', N'Loves mystery novels.', N'Mystery, Thriller', CAST(N'2024-10-23T16:11:18.043' AS DateTime), CAST(N'2024-10-23T16:11:18.043' AS DateTime))
INSERT [dbo].[users] ([user_id], [user_role], [user_full_name], [user_email], [user_password], [user_preferences], [user_address], [bio], [favorite_genres], [user_last_updated_datetime], [user_creation_datetime]) VALUES (701003, N'User', N'Arun Kumar', N'arun.kumar@gmail.com', N'h3bxCOJHqx4rMjBCwEnCZkB8gfutQb3h6N/Bu2b9Jn4=', N'Romance, Adventure', N'10, Besant Nagar, Chennai, Tamil Nadu - 600090', N'Enjoys adventure stories.', N'Romance, Adventure', CAST(N'2024-10-23T16:11:18.043' AS DateTime), CAST(N'2024-10-23T16:11:18.043' AS DateTime))
INSERT [dbo].[users] ([user_id], [user_role], [user_full_name], [user_email], [user_password], [user_preferences], [user_address], [bio], [favorite_genres], [user_last_updated_datetime], [user_creation_datetime]) VALUES (701004, N'User', N'Rajesh R', N'rajesh@gmail.com', N'h3bxCOJHqx4rMjBCwEnCZkB8gfutQb3h6N/Bu2b9Jn4=', N'Science Fiction, Fantasy', N'5, Kodambakkam, Chennai, Tamil Nadu - 600024', N'Sci-fi enthusiast.', N'Science Fiction, Fantasy', CAST(N'2024-10-23T16:11:18.043' AS DateTime), CAST(N'2024-10-23T16:11:18.043' AS DateTime))
INSERT [dbo].[users] ([user_id], [user_role], [user_full_name], [user_email], [user_password], [user_preferences], [user_address], [bio], [favorite_genres], [user_last_updated_datetime], [user_creation_datetime]) VALUES (701005, N'User', N'Priya M', N'priya@gmail.com', N'h3bxCOJHqx4rMjBCwEnCZkB8gfutQb3h6N/Bu2b9Jn4=', N'Fiction, History', N'12, Mylapore, Chennai, Tamil Nadu - 600004', N'Fan of historical novels.', N'Fiction, History', CAST(N'2024-10-23T16:11:18.043' AS DateTime), CAST(N'2024-10-23T16:11:18.043' AS DateTime))
INSERT [dbo].[users] ([user_id], [user_role], [user_full_name], [user_email], [user_password], [user_preferences], [user_address], [bio], [favorite_genres], [user_last_updated_datetime], [user_creation_datetime]) VALUES (701006, N'User', N'Karthik S', N'karthik@gmail.com', N'h3bxCOJHqx4rMjBCwEnCZkB8gfutQb3h6N/Bu2b9Jn4=', N'Romance, Thriller', N'34, Velachery, Chennai, Tamil Nadu - 600042', N'Likes romantic thrillers.', N'Romance, Thriller', CAST(N'2024-10-23T16:11:18.043' AS DateTime), CAST(N'2024-10-23T16:11:18.043' AS DateTime))
INSERT [dbo].[users] ([user_id], [user_role], [user_full_name], [user_email], [user_password], [user_preferences], [user_address], [bio], [favorite_genres], [user_last_updated_datetime], [user_creation_datetime]) VALUES (701007, N'User', N'Sneha S', N'sneha@gmail.com', N'h3bxCOJHqx4rMjBCwEnCZkB8gfutQb3h6N/Bu2b9Jn4=', N'Mystery, Non-Fiction', N'22, Ekkatuthangal, Chennai, Tamil Nadu - 600032', N'Enjoys mystery and true crime.', N'Mystery, Non-Fiction', CAST(N'2024-10-23T16:11:18.043' AS DateTime), CAST(N'2024-10-23T16:11:18.043' AS DateTime))
INSERT [dbo].[users] ([user_id], [user_role], [user_full_name], [user_email], [user_password], [user_preferences], [user_address], [bio], [favorite_genres], [user_last_updated_datetime], [user_creation_datetime]) VALUES (701008, N'User', N'Mohan R', N'mohan@gmail.com', N'h3bxCOJHqx4rMjBCwEnCZkB8gfutQb3h6N/Bu2b9Jn4=', N'Fiction, Thriller', N'40, Kotturpuram, Chennai, Tamil Nadu - 600085', N'Enjoys thrillers and fiction.', N'Fiction, Thriller', CAST(N'2024-10-23T16:11:18.043' AS DateTime), CAST(N'2024-10-23T16:11:18.043' AS DateTime))
INSERT [dbo].[users] ([user_id], [user_role], [user_full_name], [user_email], [user_password], [user_preferences], [user_address], [bio], [favorite_genres], [user_last_updated_datetime], [user_creation_datetime]) VALUES (701009, N'User', N'Anjali T', N'anjali@gmail.com', N'h3bxCOJHqx4rMjBCwEnCZkB8gfutQb3h6N/Bu2b9Jn4=', N'Fantasy, Adventure', N'11, Anna Salai, Chennai, Tamil Nadu - 600002', N'Adventurous reader.', N'Fantasy, Adventure', CAST(N'2024-10-23T16:11:18.043' AS DateTime), CAST(N'2024-10-23T16:11:18.043' AS DateTime))
INSERT [dbo].[users] ([user_id], [user_role], [user_full_name], [user_email], [user_password], [user_preferences], [user_address], [bio], [favorite_genres], [user_last_updated_datetime], [user_creation_datetime]) VALUES (701010, N'User', N'Suresh P', N'suresh@gmail.com', N'h3bxCOJHqx4rMjBCwEnCZkB8gfutQb3h6N/Bu2b9Jn4=', N'Fiction, Biography', N'9, Saidapet, Chennai, Tamil Nadu - 600015', N'Likes biographies and fiction.', N'Fiction, Biography', CAST(N'2024-10-23T16:11:18.043' AS DateTime), CAST(N'2024-10-23T16:11:18.043' AS DateTime))
INSERT [dbo].[users] ([user_id], [user_role], [user_full_name], [user_email], [user_password], [user_preferences], [user_address], [bio], [favorite_genres], [user_last_updated_datetime], [user_creation_datetime]) VALUES (701011, N'User', N'Santhosh', N'santhosh@gmail.com', N'hJ8Vdcz786TWzwDmxWQbf9TaLtPiEsLXm6kWGlpDL/A=', N'Thriller', N'', N'', N'Thriller', CAST(N'2024-11-15T12:22:46.903' AS DateTime), CAST(N'2024-11-15T11:45:32.897' AS DateTime))
SET IDENTITY_INSERT [dbo].[users] OFF
GO
ALTER TABLE [dbo].[books] ADD  DEFAULT (getdate()) FOR [book_last_updated_datetime]
GO
ALTER TABLE [dbo].[books] ADD  DEFAULT (getdate()) FOR [book_creation_datetime]
GO
ALTER TABLE [dbo].[exchange_requests] ADD  DEFAULT (getdate()) FOR [exchange_request_last_updated_datetime]
GO
ALTER TABLE [dbo].[exchange_requests] ADD  DEFAULT (getdate()) FOR [exchange_request_creation_datetime]
GO
ALTER TABLE [dbo].[messages] ADD  DEFAULT (getdate()) FOR [message_send_datetime]
GO
ALTER TABLE [dbo].[transaction_history] ADD  DEFAULT (getdate()) FOR [transaction_last_updated_datetime]
GO
ALTER TABLE [dbo].[transaction_history] ADD  DEFAULT (getdate()) FOR [transaction_creation_datetime]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT (getdate()) FOR [user_creation_datetime]
GO
ALTER TABLE [dbo].[books]  WITH CHECK ADD  CONSTRAINT [FK_books_users] FOREIGN KEY([book_user_id])
REFERENCES [dbo].[users] ([user_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[books] CHECK CONSTRAINT [FK_books_users]
GO
ALTER TABLE [dbo].[exchange_requests]  WITH CHECK ADD  CONSTRAINT [FK_exchange_requests_books] FOREIGN KEY([exchange_request_book_id])
REFERENCES [dbo].[books] ([book_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[exchange_requests] CHECK CONSTRAINT [FK_exchange_requests_books]
GO
ALTER TABLE [dbo].[exchange_requests]  WITH CHECK ADD  CONSTRAINT [FK_exchange_requests_users] FOREIGN KEY([exchange_request_sender_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[exchange_requests] CHECK CONSTRAINT [FK_exchange_requests_users]
GO
ALTER TABLE [dbo].[exchange_requests]  WITH CHECK ADD  CONSTRAINT [FK_exchange_requests_users1] FOREIGN KEY([exchange_request_receiver_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[exchange_requests] CHECK CONSTRAINT [FK_exchange_requests_users1]
GO
ALTER TABLE [dbo].[messages]  WITH NOCHECK ADD  CONSTRAINT [FK_messages_exchange_requests] FOREIGN KEY([message_exchange_request_id])
REFERENCES [dbo].[exchange_requests] ([exchange_request_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[messages] NOCHECK CONSTRAINT [FK_messages_exchange_requests]
GO
ALTER TABLE [dbo].[messages]  WITH NOCHECK ADD  CONSTRAINT [FK_messages_users] FOREIGN KEY([message_sender_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[messages] NOCHECK CONSTRAINT [FK_messages_users]
GO
ALTER TABLE [dbo].[messages]  WITH NOCHECK ADD  CONSTRAINT [FK_messages_users1] FOREIGN KEY([message_receiver_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[messages] NOCHECK CONSTRAINT [FK_messages_users1]
GO
ALTER TABLE [dbo].[transaction_history]  WITH NOCHECK ADD  CONSTRAINT [FK_transaction_history_exchange_requests] FOREIGN KEY([transaction_exchange_request_id])
REFERENCES [dbo].[exchange_requests] ([exchange_request_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[transaction_history] NOCHECK CONSTRAINT [FK_transaction_history_exchange_requests]
GO
USE [master]
GO
ALTER DATABASE [BookExchangeDB] SET  READ_WRITE 
GO
