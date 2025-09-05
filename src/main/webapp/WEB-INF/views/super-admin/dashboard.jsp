<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - Quản lý Phòng trọ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .sidebar {
            background: linear-gradient(135deg, #dc3545 0%, #6f42c1 100%);
            min-height: 100vh;
            color: white;
        }
        
        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.8);
            border-radius: 10px;
            margin: 2px 0;
        }
        
        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            background: rgba(255, 255, 255, 0.1);
            color: white;
        }
        
        .main-content {
            background: #f8f9fa;
            min-height: 100vh;
        }
        
        .navbar {
            background: white;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .card-header {
            background: linear-gradient(135deg, #dc3545 0%, #6f42c1 100%);
            color: white;
            border-radius: 15px 15px 0 0 !important;
        }
        
        .stats-card {
            background: linear-gradient(135deg, #dc3545 0%, #6f42c1 100%);
            color: white;
            border-radius: 15px;
        }
        
        /* Clickable card styles */
        .clickable-card {
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .clickable-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
        }
        
        .clickable-card:active {
            transform: translateY(-2px);
        }
        
        .super-admin-badge {
            background: linear-gradient(135deg, #dc3545 0%, #6f42c1 100%);
            color: white;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 0.7rem;
            font-weight: bold;
        }
        
        .admin-card {
            transition: all 0.3s ease;
        }
        
        .admin-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        
        .log-item {
            border-left: 4px solid #dc3545;
            padding-left: 15px;
            margin-bottom: 15px;
        }
        
        .log-item.create { border-left-color: #28a745; }
        .log-item.update { border-left-color: #17a2b8; }
        .log-item.delete { border-left-color: #dc3545; }
        .log-item.reset { border-left-color: #ffc107; }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 sidebar">
                <div class="p-3">
                    <h4 class="text-center mb-4">
                        <i class="bi bi-shield-fill-exclamation me-2"></i>
                        Super Admin
                    </h4>
                    
                    <div class="text-center mb-4">
                        <div class="bg-light text-dark rounded-circle d-inline-flex align-items-center justify-content-center" 
                             style="width: 60px; height: 60px;">
                            <i class="bi bi-shield-fill-exclamation fs-3"></i>
                        </div>
                        <div class="mt-2">
                            <strong>${user.fullName}</strong>
                            <br>
                            <span class="super-admin-badge">SUPER ADMIN</span>
                        </div>
                    </div>
                    
                    <nav class="nav flex-column">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/super-admin/dashboard">
                            <i class="bi bi-speedometer2 me-2"></i>
                            Bảng điều khiển
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/super-admin/admins">
                            <i class="bi bi-person-gear me-2"></i>
                            Quản lý Admin
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/super-admin/audit-logs">
                            <i class="bi bi-journal-text me-2"></i>
                            Nhật ký hoạt động
                        </a>
                        <hr class="text-light">
                        <a class="nav-link text-warning" href="${pageContext.request.contextPath}/logout">
                            <i class="bi bi-box-arrow-right me-2"></i>
                            Đăng xuất
                        </a>
                    </nav>
                </div>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-9 col-lg-10 main-content">
                <!-- Top Navigation -->
                <nav class="navbar navbar-expand-lg navbar-light">
                    <div class="container-fluid">
                        <h5 class="navbar-brand mb-0">
                            <i class="bi bi-shield-fill-exclamation text-danger me-2"></i>
                            ${pageTitle}
                        </h5>
                        <div class="navbar-nav ms-auto">
                            <div class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                                    <i class="bi bi-shield-fill-exclamation me-1 text-danger"></i>
                                    ${user.fullName}
                                </a>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="#">Thông tin cá nhân</a></li>
                                    <li><a class="dropdown-item" href="#">Cài đặt hệ thống</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </nav>
                
                <!-- Dashboard Content -->
                <div class="p-4">
                    <!-- Welcome Card -->
                    <div class="card mb-4">
                        <div class="card-body">
                            <div class="row align-items-center">
                                <div class="col">
                                    <h4>Chào mừng Super Admin, ${user.fullName}!</h4>
                                    <p class="text-muted mb-0">Quản lý toàn bộ hệ thống và các quản trị viên</p>
                                </div>
                                <div class="col-auto">
                                    <i class="bi bi-shield-fill-exclamation fs-1 text-danger"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- System Statistics Cards -->
                    <div class="row mb-4">
                        <!-- Total Super Admins -->
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="card bg-danger text-white">
                                <div class="card-body text-center">
                                    <i class="bi bi-shield-fill-exclamation fs-1 mb-2"></i>
                                    <h3>${systemStats.totalSuperAdmins}</h3>
                                    <p class="mb-0">Super Admin</p>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Total Admins -->
                        <div class="col-lg-3 col-md-6 mb-3">
                            <a href="${pageContext.request.contextPath}/super-admin/admins" class="text-decoration-none">
                                <div class="card bg-primary text-white clickable-card">
                                    <div class="card-body text-center">
                                        <i class="bi bi-person-gear fs-1 mb-2"></i>
                                        <h3>${systemStats.totalAdmins}</h3>
                                        <p class="mb-0">Quản trị viên</p>
                                        <small>Hoạt động: ${systemStats.activeAdmins}</small>
                                    </div>
                                </div>
                            </a>
                        </div>
                        
                        <!-- Total Users -->
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="card bg-success text-white">
                                <div class="card-body text-center">
                                    <i class="bi bi-people-fill fs-1 mb-2"></i>
                                    <h3>${systemStats.totalUsers}</h3>
                                    <p class="mb-0">Người dùng</p>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Total Rooms -->
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="card bg-info text-white">
                                <div class="card-body text-center">
                                    <i class="bi bi-building fs-1 mb-2"></i>
                                    <h3>${systemStats.totalRooms}</h3>
                                    <p class="mb-0">Tổng phòng</p>
                                    <small>Đã thuê: ${systemStats.occupiedRooms}</small>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Revenue and System Health -->
                    <div class="row mb-4">
                        <!-- Total Revenue -->
                        <div class="col-lg-4 col-md-6 mb-3">
                            <div class="card bg-success text-white">
                                <div class="card-body text-center">
                                    <i class="bi bi-currency-dollar fs-1 mb-2"></i>
                                    <h3>
                                        <c:choose>
                                            <c:when test="${systemStats.totalRevenue != null}">
                                                <fmt:formatNumber value="${systemStats.totalRevenue}" type="number" maxFractionDigits="0" groupingUsed="true"/>
                                            </c:when>
                                            <c:otherwise>0</c:otherwise>
                                        </c:choose>
                                    </h3>
                                    <p class="mb-0">Tổng doanh thu (VNĐ)</p>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Monthly Revenue -->
                        <div class="col-lg-4 col-md-6 mb-3">
                            <div class="card bg-warning text-white">
                                <div class="card-body text-center">
                                    <i class="bi bi-calendar-month fs-1 mb-2"></i>
                                    <h3>
                                        <c:choose>
                                            <c:when test="${systemStats.monthlyRevenue != null}">
                                                <fmt:formatNumber value="${systemStats.monthlyRevenue}" type="number" maxFractionDigits="0" groupingUsed="true"/>
                                            </c:when>
                                            <c:otherwise>0</c:otherwise>
                                        </c:choose>
                                    </h3>
                                    <p class="mb-0">Doanh thu tháng này</p>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Unpaid Invoices -->
                        <div class="col-lg-4 col-md-6 mb-3">
                            <div class="card bg-danger text-white">
                                <div class="card-body text-center">
                                    <i class="bi bi-exclamation-triangle fs-1 mb-2"></i>
                                    <h3>${systemStats.unpaidInvoices}</h3>
                                    <p class="mb-0">Hóa đơn chưa TT</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Admin Management and Recent Activity -->
                    <div class="row">
                        <!-- Managed Admins -->
                        <div class="col-lg-6 mb-4">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">
                                        <i class="bi bi-person-gear me-2"></i>
                                        Admin được quản lý
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <c:choose>
                                        <c:when test="${not empty managedAdmins}">
                                            <c:forEach var="admin" items="${managedAdmins}" varStatus="status">
                                                <c:if test="${status.index < 5}">
                                                    <div class="admin-card p-3 mb-3 border rounded">
                                                        <div class="row align-items-center">
                                                            <div class="col">
                                                                <h6 class="mb-1">${admin.adminName}</h6>
                                                                <small class="text-muted">
                                                                    <i class="bi bi-envelope me-1"></i>${admin.adminEmail}
                                                                </small>
                                                                <br>
                                                                <span class="badge ${admin.statusBadgeClass} mt-1">
                                                                    <i class="${admin.statusIcon} me-1"></i>
                                                                    ${admin.statusDisplayName}
                                                                </span>
                                                            </div>
                                                            <div class="col-auto">
                                                                <small class="text-muted">
                                                                    ${admin.formattedAssignedDate}
                                                                </small>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </c:forEach>
                                            <c:if test="${managedAdmins.size() > 5}">
                                                <div class="text-center">
                                                    <a href="${pageContext.request.contextPath}/super-admin/admins" class="btn btn-outline-primary btn-sm">
                                                        Xem tất cả (${managedAdmins.size()})
                                                    </a>
                                                </div>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-center text-muted py-4">
                                                <i class="bi bi-person-gear fs-1 mb-3"></i>
                                                <p>Chưa có admin nào được quản lý</p>
                                                <a href="${pageContext.request.contextPath}/super-admin/admins" class="btn btn-primary">
                                                    Thêm Admin mới
                                                </a>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Recent Activity -->
                        <div class="col-lg-6 mb-4">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">
                                        <i class="bi bi-activity me-2"></i>
                                        Hoạt động gần đây
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <c:choose>
                                        <c:when test="${not empty recentLogs}">
                                            <c:forEach var="log" items="${recentLogs}" varStatus="status">
                                                <c:if test="${status.index < 5}">
                                                    <div class="log-item ${log.action.toLowerCase()}">
                                                        <div class="d-flex justify-content-between align-items-start">
                                                            <div>
                                                                <span class="badge ${log.actionBadgeClass} mb-1">
                                                                    <i class="${log.actionIcon} me-1"></i>
                                                                    ${log.actionDisplayName}
                                                                </span>
                                                                <p class="mb-1 small">${log.shortDescription}</p>
                                                                <small class="text-muted">
                                                                    <i class="bi bi-clock me-1"></i>
                                                                    ${log.relativeTime}
                                                                </small>
                                                            </div>
                                                            <c:if test="${log.criticalAction}">
                                                                <i class="bi bi-exclamation-triangle text-danger"></i>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </c:forEach>
                                            <div class="text-center">
                                                <a href="${pageContext.request.contextPath}/super-admin/audit-logs" class="btn btn-outline-secondary btn-sm">
                                                    Xem tất cả hoạt động
                                                </a>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-center text-muted py-4">
                                                <i class="bi bi-activity fs-1 mb-3"></i>
                                                <p>Chưa có hoạt động nào</p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Quick Actions -->
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="bi bi-lightning-charge me-2"></i>
                                Thao tác nhanh
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <a href="${pageContext.request.contextPath}/super-admin/admins/add" 
                                       class="btn btn-outline-primary btn-lg w-100">
                                        <i class="bi bi-person-plus fs-4 d-block mb-2"></i>
                                        Thêm Admin mới
                                    </a>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <a href="${pageContext.request.contextPath}/super-admin/admins" 
                                       class="btn btn-outline-success btn-lg w-100">
                                        <i class="bi bi-person-gear fs-4 d-block mb-2"></i>
                                        Quản lý Admin
                                    </a>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <a href="${pageContext.request.contextPath}/super-admin/audit-logs" 
                                       class="btn btn-outline-warning btn-lg w-100">
                                        <i class="bi bi-journal-text fs-4 d-block mb-2"></i>
                                        Nhật ký hoạt động
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>