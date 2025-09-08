@echo off
REM =============================================================================
REM Docker Deployment Script for Windows
REM =============================================================================

echo ===============================================
echo DOCKER DEPLOYMENT - QUAN LY PHONG TRO
echo ===============================================
echo.

REM Check if Docker is installed
echo [INFO] Checking Docker installation...
docker --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker is not installed or not running!
    echo.
    echo Please install Docker Desktop:
    echo 1. Download from: https://www.docker.com/products/docker-desktop
    echo 2. Install and start Docker Desktop
    echo 3. Make sure Docker is running (check system tray)
    echo 4. Run this script again
    echo.
    pause
    exit /b 1
)

echo [SUCCESS] Docker is installed
docker --version

echo.

REM Check if Docker Compose is available
echo [INFO] Checking Docker Compose...
docker compose version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker Compose not available!
    echo Please make sure you have Docker Desktop with Compose support
    pause
    exit /b 1
)

echo [SUCCESS] Docker Compose is available
docker compose version

echo.

REM Check if we're in the right directory
if not exist "pom.xml" (
    echo [ERROR] pom.xml not found. Please run from project directory.
    pause
    exit /b 1
)

if not exist "Dockerfile" (
    echo [ERROR] Dockerfile not found. Please ensure Dockerfile exists.
    pause
    exit /b 1
)

if not exist "docker-compose.yml" (
    echo [ERROR] docker-compose.yml not found. Please ensure docker-compose.yml exists.
    pause
    exit /b 1
)

echo [SUCCESS] All required files found
echo.

REM Show deployment information
echo ==============================================
echo DEPLOYMENT INFORMATION
echo ==============================================
echo.
echo This will deploy:
echo   - MySQL 8.0 database (port 3306)
echo   - Quan Ly Phong Tro application (port 8080)
echo   - phpMyAdmin (port 8081)
echo.
echo After deployment, access:
echo   - Application: http://localhost:8080/
echo   - phpMyAdmin: http://localhost:8081/
echo.
echo Default login accounts:
echo   - Super Admin: superadmin / superadmin123
echo   - Admin: admin / admin123
echo   - User: user1 / user123
echo.

set /p proceed="Do you want to proceed with Docker deployment? (y/N): "
if /i not "%proceed%"=="y" (
    echo Deployment cancelled.
    pause
    exit /b 0
)

echo.
echo ==============================================
echo STARTING DEPLOYMENT
echo ==============================================
echo.

REM Stop any existing containers
echo [INFO] Stopping any existing containers...
docker compose down 2>nul

REM Remove old images (optional)
echo [INFO] Cleaning up old images...
docker image prune -f >nul 2>&1

REM Build and start services
echo [INFO] Building and starting services...
echo This may take several minutes for the first time...
echo.

docker compose up --build -d

if errorlevel 1 (
    echo [ERROR] Docker deployment failed!
    echo.
    echo Troubleshooting:
    echo 1. Check if Docker Desktop is running
    echo 2. Check if ports 8080, 8081, 3306 are free
    echo 3. Check Docker logs: docker compose logs
    echo.
    pause
    exit /b 1
)

echo.
echo [SUCCESS] Containers started successfully!
echo.

REM Wait for services to be ready
echo [INFO] Waiting for services to be ready...
echo This may take 1-2 minutes...
echo.

REM Wait for MySQL to be ready
echo [INFO] Waiting for MySQL to be ready...
set /a MYSQL_WAIT=0
:MYSQL_WAIT_LOOP
docker compose exec mysql mysqladmin ping -h localhost --silent >nul 2>&1
if not errorlevel 1 (
    echo [SUCCESS] MySQL is ready!
    goto MYSQL_READY
)
timeout /t 5 /nobreak >nul
set /a MYSQL_WAIT+=1
if %MYSQL_WAIT% LSS 24 goto MYSQL_WAIT_LOOP

echo [WARNING] MySQL taking longer than expected...

:MYSQL_READY
echo.

REM Wait for application to be ready
echo [INFO] Waiting for application to be ready...
set /a APP_WAIT=0
:APP_WAIT_LOOP
curl -f http://localhost:8080/ >nul 2>&1
if not errorlevel 1 (
    echo [SUCCESS] Application is ready!
    goto APP_READY
)
timeout /t 5 /nobreak >nul
set /a APP_WAIT+=1
if %APP_WAIT% LSS 24 goto APP_WAIT_LOOP

echo [WARNING] Application taking longer than expected...

:APP_READY
echo.

REM Show container status
echo [INFO] Container status:
docker compose ps

echo.
echo ==============================================
echo DEPLOYMENT COMPLETED SUCCESSFULLY!
echo ==============================================
echo.
echo 🌐 Access URLs:
echo   📱 Main Application: http://localhost:8080/
echo   👨‍💼 Admin Dashboard: http://localhost:8080/admin/dashboard
echo   🔧 Super Admin: http://localhost:8080/super-admin/dashboard
echo   🗄️  phpMyAdmin: http://localhost:8081/
echo.
echo 👤 Default Login Accounts:
echo   Super Admin: superadmin / superadmin123
echo   Admin: admin / admin123
echo   User: user1 / user123
echo.
echo 🐳 Docker Commands:
echo   View logs: docker compose logs -f
echo   Stop services: docker compose down
echo   Restart services: docker compose restart
echo   View status: docker compose ps
echo.
echo 🔧 Database Access (phpMyAdmin):
echo   URL: http://localhost:8081/
echo   Username: qlpt_user
echo   Password: qlpt_password
echo.
echo 📊 Next Steps:
echo   1. Open http://localhost:8080/ in your browser
echo   2. Login with default accounts
echo   3. Start using the application!
echo   4. Remember to change default passwords
echo.

REM Open browser automatically
set /p open_browser="Open application in browser now? (y/N): "
if /i "%open_browser%"=="y" (
    start http://localhost:8080/
)

echo.
echo Press any key to exit...
pause >nul