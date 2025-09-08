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
            border: 1px solid #e9ecef;
        }
        
        .admin-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            border-color: #007bff;
        }
        
        .action-btn {
            margin: 2px;
        }
        
        .status-active { color: #28a745; }
        .status-suspended { color: #ffc107; }
        .status-inactive { color: #dc3545; }
        
        .efficiency-high { color: #28a745; }
        .efficiency-medium { color: #ffc107; }
        .efficiency-low { color: #dc3545; }
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/super-admin/dashboard">
                            <i class="bi bi-speedometer2 me-2"></i>
                            Bảng điều khiển
                        </a>
                        <a class="nav-link active" href="${pageContext.request.contextPath}/super-admin/admins">
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
                            <i class="bi bi-person-gear text-primary me-2"></i>
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
                
                <!-- Content -->
                <div class="p-4">
                    <!-- Success/Error Messages -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="bi bi-check-circle me-2"></i>
                            ${success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle me-2"></i>
                            ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <!-- Header Actions -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h4 class="mb-1">Quản lý Admin</h4>
                            <p class="text-muted mb-0">Quản lý tất cả quản trị viên trong hệ thống</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/super-admin/admins/add" class="btn btn-primary">
                            <i class="bi bi-person-plus me-2"></i>
                            Thêm Admin mới
                        </a>
                    </div>
                    
                    <!-- Statistics Cards -->
                    <div class="row mb-4">
                        <div class="col-md-3">
                            <div class="card bg-primary text-white">
                                <div class="card-body text-center">
                                    <i class="bi bi-person-gear fs-2 mb-2"></i>
                                    <h4>${allAdmins.size()}</h4>
                                    <p class="mb-0">Tổng Admin</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card bg-success text-white">
                                <div class="card-body text-center">
                                    <i class="bi bi-check-circle fs-2 mb-2"></i>
                                    <h4>
                                        <c:set var="activeCount" value="0"/>
                                        <c:forEach var="admin" items="${managedAdmins}">
                                            <c:if test="${admin.active}">
                                                <c:set var="activeCount" value="${activeCount + 1}"/>
                                            </c:if>
                                        </c:forEach>
                                        ${activeCount}
                                    </h4>
                                    <p class="mb-0">Đang hoạt động</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card bg-warning text-white">
                                <div class="card-body text-center">
                                    <i class="bi bi-pause-circle fs-2 mb-2"></i>
                                    <h4>
                                        <c:set var="suspendedCount" value="0"/>
                                        <c:forEach var="admin" items="${managedAdmins}">
                                            <c:if test="${admin.suspended}">
                                                <c:set var="suspendedCount" value="${suspendedCount + 1}"/>
                                            </c:if>
                                        </c:forEach>
                                        ${suspendedCount}
                                    </h4>
                                    <p class="mb-0">Tạm khóa</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card bg-danger text-white">
                                <div class="card-body text-center">
                                    <i class="bi bi-x-circle fs-2 mb-2"></i>
                                    <h4>
                                        <c:set var="inactiveCount" value="0"/>
                                        <c:forEach var="admin" items="${managedAdmins}">
                                            <c:if test="${admin.inactive}">
                                                <c:set var="inactiveCount" value="${inactiveCount + 1}"/>
                                            </c:if>
                                        </c:forEach>
                                        ${inactiveCount}
                                    </h4>
                                    <p class="mb-0">Vô hiệu hóa</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Admin List -->
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="bi bi-list me-2"></i>
                                Danh sách Admin
                            </h5>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${not empty allAdmins}">
                                    <div class="row">
                                        <c:forEach var="admin" items="${allAdmins}">
                                            <div class="col-lg-6 col-xl-4 mb-4">
                                                <div class="admin-card card h-100">
                                                    <div class="card-body">
                                                        <!-- Admin Header -->
                                                        <div class="d-flex align-items-center mb-3">
                                                            <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3" 
                                                                 style="width: 50px; height: 50px;">
                                                                <i class="bi bi-person-gear fs-4"></i>
                                                            </div>
                                                            <div class="flex-grow-1">
                                                                <h6 class="mb-1">${admin.fullName}</h6>
                                                                <small class="text-muted">@${admin.username}</small>
                                                            </div>
                                                            <!-- Status Badge -->
                                                            <c:set var="adminManagement" value="${null}"/>
                                                            <c:forEach var="managed" items="${managedAdmins}">
                                                                <c:if test="${managed.adminId == admin.userId}">
                                                                    <c:set var="adminManagement" value="${managed}"/>
                                                                </c:if>
                                                            </c:forEach>
                                                            
                                                            <c:choose>
                                                                <c:when test="${adminManagement != null}">
                                                                    <span class="badge ${adminManagement.statusBadgeClass}">
                                                                        <i class="${adminManagement.statusIcon} me-1"></i>
                                                                        ${adminManagement.statusDisplayName}
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-secondary">
                                                                        <i class="bi bi-question-circle me-1"></i>
                                                                        Chưa quản lý
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        
                                                        <!-- Admin Info -->
                                                        <div class="mb-3">
                                                            <div class="row text-sm">
                                                                <div class="col-12 mb-2">
                                                                    <i class="bi bi-envelope text-muted me-2"></i>
                                                                    <small>${admin.email}</small>
                                                                </div>
                                                                <div class="col-12 mb-2">
                                                                    <i class="bi bi-telephone text-muted me-2"></i>
                                                                    <small>${admin.phone}</small>
                                                                </div>
                                                                <div class="col-12 mb-2">
                                                                    <i class="bi bi-calendar text-muted me-2"></i>
                                                                    <small>
                                                                        <fmt:formatDate value="${admin.createdAt}" pattern="dd/MM/yyyy"/>
                                                                    </small>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        
                                                        <!-- Statistics (if managed) -->
                                                        <c:if test="${adminManagement != null}">
                                                            <div class="row text-center mb-3">
                                                                <div class="col-4">
                                                                    <div class="border-end">
                                                                        <h6 class="mb-0">${adminManagement.totalRoomsManaged}</h6>
                                                                        <small class="text-muted">Phòng</small>
                                                                    </div>
                                                                </div>
                                                                <div class="col-4">
                                                                    <div class="border-end">
                                                                        <h6 class="mb-0">${adminManagement.totalUsersManaged}</h6>
                                                                        <small class="text-muted">Người thuê</small>
                                                                    </div>
                                                                </div>
                                                                <div class="col-4">
                                                                    <h6 class="mb-0 efficiency-${adminManagement.efficiencyLevel.toLowerCase()}">
                                                                        <i class="bi bi-graph-up"></i>
                                                                    </h6>
                                                                    <small class="text-muted">${adminManagement.efficiencyDisplayName}</small>
                                                                </div>
                                                            </div>
                                                        </c:if>
                                                        
                                                        <!-- Action Buttons -->
                                                        <div class="d-flex flex-wrap justify-content-center">
                                                            <a href="${pageContext.request.contextPath}/super-admin/admins/edit/${admin.userId}" 
                                                               class="btn btn-outline-primary btn-sm action-btn">
                                                                <i class="bi bi-pencil"></i>
                                                            </a>
                                                            
                                                            <c:if test="${adminManagement != null}">
                                                                <c:choose>
                                                                    <c:when test="${adminManagement.active}">
                                                                        <button type="button" class="btn btn-outline-warning btn-sm action-btn" 
                                                                                onclick="suspendAdmin(${admin.userId}, '${admin.fullName}')">
                                                                            <i class="bi bi-pause"></i>
                                                                        </button>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <form method="post" action="${pageContext.request.contextPath}/super-admin/admins/activate/${admin.userId}" 
                                                                              style="display: inline;">
                                                                            <button type="submit" class="btn btn-outline-success btn-sm action-btn">
                                                                                <i class="bi bi-play"></i>
                                                                            </button>
                                                                        </form>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:if>
                                                            
                                                            <button type="button" class="btn btn-outline-secondary btn-sm action-btn" 
                                                                    onclick="resetPassword(${admin.userId}, '${admin.fullName}')">
                                                                <i class="bi bi-key"></i>
                                                            </button>
                                                            
                                                            <button type="button" class="btn btn-outline-danger btn-sm action-btn" 
                                                                    onclick="deleteAdmin(${admin.userId}, '${admin.fullName}')">
                                                                <i class="bi bi-trash"></i>
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-5">
                                        <i class="bi bi-person-gear fs-1 text-muted mb-3"></i>
                                        <h5 class="text-muted">Chưa có Admin nào</h5>
                                        <p class="text-muted">Hãy thêm Admin đầu tiên để bắt đầu quản lý hệ thống</p>
                                        <a href="${pageContext.request.contextPath}/super-admin/admins/add" class="btn btn-primary">
                                            <i class="bi bi-person-plus me-2"></i>
                                            Thêm Admin mới
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Suspend Admin Modal -->
    <div class="modal fade" id="suspendModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Tạm khóa Admin</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="suspendForm" method="post">
                    <div class="modal-body">
                        <p>Bạn có chắc chắn muốn tạm khóa Admin <strong id="suspendAdminName"></strong>?</p>
                        <div class="mb-3">
                            <label for="suspendReason" class="form-label">Lý do tạm khóa:</label>
                            <textarea class="form-control" id="suspendReason" name="reason" rows="3" 
                                      placeholder="Nhập lý do tạm khóa..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-warning">Tạm khóa</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Reset Password Modal -->
    <div class="modal fade" id="resetPasswordModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Reset mật khẩu</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="resetPasswordForm" method="post">
                    <div class="modal-body">
                        <p>Bạn có chắc chắn muốn reset mật khẩu cho Admin <strong id="resetAdminName"></strong>?</p>
                        <div class="alert alert-warning">
                            <i class="bi bi-exclamation-triangle me-2"></i>
                            Mật khẩu mới sẽ được tạo tự động và hiển thị sau khi reset.
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-warning">Reset mật khẩu</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Delete Admin Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Xóa Admin</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="deleteForm" method="post">
                    <div class="modal-body">
                        <p>Bạn có chắc chắn muốn xóa Admin <strong id="deleteAdminName"></strong>?</p>
                        <div class="alert alert-danger">
                            <i class="bi bi-exclamation-triangle me-2"></i>
                            Hành động này sẽ vô hiệu hóa tài khoản admin và không thể hoàn tác.
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-danger">Xóa Admin</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function suspendAdmin(adminId, adminName) {
            document.getElementById('suspendAdminName').textContent = adminName;
            document.getElementById('suspendForm').action = '${pageContext.request.contextPath}/super-admin/admins/suspend/' + adminId;
            new bootstrap.Modal(document.getElementById('suspendModal')).show();
        }
        
        function resetPassword(adminId, adminName) {
            document.getElementById('resetAdminName').textContent = adminName;
            document.getElementById('resetPasswordForm').action = '${pageContext.request.contextPath}/super-admin/admins/reset-password/' + adminId;
            new bootstrap.Modal(document.getElementById('resetPasswordModal')).show();
        }
        
        function deleteAdmin(adminId, adminName) {
            document.getElementById('deleteAdminName').textContent = adminName;
            document.getElementById('deleteForm').action = '${pageContext.request.contextPath}/super-admin/admins/delete/' + adminId;
            new bootstrap.Modal(document.getElementById('deleteModal')).show();
        }
    </script>
</body>
</html>