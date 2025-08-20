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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px 15px 0 0 !important;
        }
        
        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
        }
        
        .badge-user {
            background: #28a745;
        }
        
        .badge-admin {
            background: #dc3545;
        }
        
        .table th {
            border: none;
            background: #f8f9fa;
            font-weight: 600;
        }
        
        .search-filter-row {
            background: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 sidebar">
                <div class="p-3">
                    <h4 class="text-center mb-4">
                        <i class="bi bi-building me-2"></i>
                        Admin Panel
                    </h4>
                    
                    <div class="text-center mb-4">
                        <div class="bg-light text-dark rounded-circle d-inline-flex align-items-center justify-content-center" 
                             style="width: 60px; height: 60px;">
                            <i class="bi bi-person-gear fs-3"></i>
                        </div>
                        <div class="mt-2">
                            <strong>${user.fullName}</strong>
                            <br>
                            <small class="text-light">Quản trị viên</small>
                        </div>
                    </div>
                    
                    <nav class="nav flex-column">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="bi bi-speedometer2 me-2"></i>
                            Bảng điều khiển
                        </a>
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/users">
                            <i class="bi bi-people me-2"></i>
                            Quản lý Người dùng
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/rooms">
                            <i class="bi bi-door-open me-2"></i>
                            Quản lý Phòng trọ
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/services">
                            <i class="bi bi-tools me-2"></i>
                            Quản lý Dịch vụ
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/tenants">
                            <i class="bi bi-person-check me-2"></i>
                            Quản lý Thuê trọ
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/additional-costs">
                            <i class="bi bi-receipt-cutoff me-2"></i>
                            Chi phí phát sinh
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/bills">
                            <i class="bi bi-receipt me-2"></i>
                            Quản lý Hóa đơn
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/messages">
                            <i class="bi bi-chat-dots me-2"></i>
                            Tin nhắn
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/reports">
                            <i class="bi bi-graph-up me-2"></i>
                            Báo cáo & Thống kê
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
                        <h5 class="navbar-brand mb-0">${pageTitle}</h5>
                        <div class="navbar-nav ms-auto">
                            <div class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                                    <i class="bi bi-person-circle me-1"></i>
                                    ${user.fullName}
                                </a>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="#">Thông tin cá nhân</a></li>
                                    <li><a class="dropdown-item" href="#">Cài đặt</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </nav>
                
                <!-- User Management Content -->
                <div class="p-4">
                    <!-- Success/Error Messages -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="bi bi-check-circle-fill me-2"></i>
                            ${success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>
                            ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <!-- Statistics Cards -->
                    <div class="row mb-4">
                        <div class="col-md-3 mb-3">
                            <div class="card stats-card">
                                <div class="card-body text-center">
                                    <i class="bi bi-people fs-1 mb-2"></i>
                                    <h3>${totalUsers}</h3>
                                    <p class="mb-0">Tổng Người dùng</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 mb-3">
                            <div class="card bg-success text-white">
                                <div class="card-body text-center">
                                    <i class="bi bi-person fs-1 mb-2"></i>
                                    <h3>${regularUsers}</h3>
                                    <p class="mb-0">Người dùng thường</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 mb-3">
                            <div class="card bg-warning text-white">
                                <div class="card-body text-center">
                                    <i class="bi bi-shield-check fs-1 mb-2"></i>
                                    <h3>${adminUsers}</h3>
                                    <p class="mb-0">Quản trị viên</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 mb-3">
                            <div class="card bg-info text-white">
                                <div class="card-body text-center">
                                    <i class="bi bi-house-heart fs-1 mb-2"></i>
                                    <h3>${activeTenantsCount}</h3>
                                    <p class="mb-0">Đang thuê trọ</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Search and Filter -->
                    <div class="search-filter-row">
                        <form method="GET" action="${pageContext.request.contextPath}/admin/users">
                            <div class="row">
                                <div class="col-md-6">
                                    <label for="search" class="form-label">Tìm kiếm người dùng</label>
                                    <div class="input-group">
                                        <input type="text" class="form-control" id="search" name="search" 
                                               placeholder="Tìm theo tên, username hoặc email..." 
                                               value="${searchTerm}">
                                        <button class="btn btn-outline-primary" type="submit">
                                            <i class="bi bi-search"></i>
                                        </button>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <label for="role" class="form-label">Lọc theo vai trò</label>
                                    <select class="form-select" id="role" name="role" onchange="this.form.submit()">
                                        <option value="all" ${selectedRole == 'all' ? 'selected' : ''}>Tất cả</option>
                                        <option value="USER" ${selectedRole == 'USER' ? 'selected' : ''}>Người dùng</option>
                                        <option value="ADMIN" ${selectedRole == 'ADMIN' ? 'selected' : ''}>Quản trị viên</option>
                                    </select>
                                </div>
                                <div class="col-md-3 d-flex align-items-end">
                                    <a href="${pageContext.request.contextPath}/admin/users/add" 
                                       class="btn btn-success w-100">
                                        <i class="bi bi-person-plus me-1"></i>
                                        Thêm người dùng
                                    </a>
                                </div>
                            </div>
                        </form>
                    </div>
                    
                    <!-- Users List -->
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">
                                <i class="bi bi-list me-2"></i>
                                Danh sách Người dùng
                            </h5>
                            <small class="text-light">${users.size()} người dùng</small>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty users}">
                                    <div class="text-center py-5">
                                        <i class="bi bi-people fs-1 text-muted mb-3"></i>
                                        <h5 class="text-muted">Không tìm thấy người dùng nào</h5>
                                        <p class="text-muted">
                                            <c:if test="${not empty searchTerm}">
                                                Không có kết quả cho từ khóa "<strong>${searchTerm}</strong>"
                                            </c:if>
                                            <c:if test="${empty searchTerm}">
                                                Chưa có người dùng nào trong hệ thống
                                            </c:if>
                                        </p>
                                        <a href="${pageContext.request.contextPath}/admin/users/add" 
                                           class="btn btn-success">
                                            <i class="bi bi-person-plus me-1"></i>
                                            Thêm người dùng đầu tiên
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Tên đăng nhập</th>
                                                    <th>Họ tên</th>
                                                    <th>Email</th>
                                                    <th>Vai trò</th>
                                                    <th>Ngày tạo</th>
                                                    <th>Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="targetUser" items="${users}">
                                                    <tr>
                                                        <td>${targetUser.userId}</td>
                                                        <td>
                                                            <strong>${targetUser.username}</strong>
                                                        </td>
                                                        <td>${targetUser.fullName}</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty targetUser.email}">
                                                                    <a href="mailto:${targetUser.email}">${targetUser.email}</a>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">Chưa cập nhật</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${targetUser.role == 'ADMIN'}">
                                                                    <span class="badge badge-admin">Quản trị viên</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge badge-user">Người dùng</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <fmt:formatDate value="${targetUser.createdAt}" pattern="dd/MM/yyyy"/>
                                                        </td>
                                                        <td>
                                                            <div class="btn-group" role="group">
                                                                <a href="${pageContext.request.contextPath}/admin/users/view/${targetUser.userId}" 
                                                                   class="btn btn-outline-info btn-sm" 
                                                                   title="Xem chi tiết">
                                                                    <i class="bi bi-eye"></i>
                                                                </a>
                                                                <c:if test="${targetUser.role != 'ADMIN'}">
                                                                    <button type="button" 
                                                                            class="btn btn-outline-danger btn-sm" 
                                                                            title="Xóa"
                                                                            onclick="confirmDelete(${targetUser.userId}, '${targetUser.fullName}')">
                                                                        <i class="bi bi-trash"></i>
                                                                    </button>
                                                                </c:if>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Xác nhận xóa</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn xóa người dùng <strong id="userNameToDelete"></strong>?</p>
                    <p class="text-warning">
                        <i class="bi bi-exclamation-triangle me-1"></i>
                        Hành động này không thể hoàn tác!
                    </p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <form id="deleteForm" method="POST" style="display: inline;">
                        <button type="submit" class="btn btn-danger">Xóa</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmDelete(userId, userName) {
            document.getElementById('userNameToDelete').textContent = userName;
            document.getElementById('deleteForm').action = '${pageContext.request.contextPath}/admin/users/delete/' + userId;
            
            var deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
            deleteModal.show();
        }
    </script>
</body>
</html>
