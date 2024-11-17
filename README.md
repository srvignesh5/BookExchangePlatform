# Book Exchange Platform  

The **Book Exchange Platform** is a full-stack web application for exchanging books. Users can manage books, create exchange requests, chat in real-time, and track transactions.  

- **Backend**: .NET Core WebAPI (Runs on `http://localhost:5000`)  
- **Frontend**: Angular (Runs on `http://localhost:4200`)  
- **Database**: SQL Server  


## Prerequisites  

1. **Visual Studio Code**  
2. **Node.js** (v20.12.2, npm 10.5.0)  
3. **SQL Server**  
4. **.NET 8.0 SDK**  
5. **Angular CLI**  
   ```bash
   npm install -g @angular/cli@16.2.16
   ```  

---

## Setup Instructions  

### 1. Clone the Repository  

```bash
git clone https://github.com/srvignesh5/BookExchangePlatform.git
cd BookExchangePlatform
```

### 2. Set Up the Database  

1. Open `BookExchangePlatform.sql` in **SQL Server Management Studio (SSMS)**.  
2. Run the script to create the database and tables.  
3. Update the connection string in `BookExchangeAPI/appsettings.json`:  
   ```json
   "ConnectionStrings": {
     "DefaultConnection": "Data Source=YOUR_SERVER_NAME;Initial Catalog=BookExchangeDB;Integrated Security=true;TrustServerCertificate=True;"
   }
   ```

### 3. Run the Backend  

1. Navigate to the backend folder:  
   ```bash
   cd BookExchangeAPI
   ```
2. Run the backend:  
   ```bash
   dotnet watch
   ```
3. The backend will run at `http://localhost:5000`.  

### 4. Run the Frontend  

1. Navigate to the frontend folder:  
   ```bash
   cd ../BookExchangeApp
   ```
2. Install the required dependencies:  
   ```bash
   npm install
   ```
3. Start the Angular application:  
   ```bash
   ng serve -o
   ```
4. The frontend will open in your browser at `http://localhost:4200`.  

## Usage  

1. Access the frontend at `http://localhost:4200`.  
2. Backend APIs are available at `http://localhost:5000`.  
3. Register or log in to manage books, create exchange requests, and chat in real-time.

---
## Demonstration Video

- **YouTube**: [Watch Here](https://youtu.be/gS1bdLWCw_M)  
- **Google Drive**: [Watch Here](https://drive.google.com/file/d/1FKFoAok15krp8RgQaUCz8wFc_I9SB5Yh/view?usp=sharing)  

