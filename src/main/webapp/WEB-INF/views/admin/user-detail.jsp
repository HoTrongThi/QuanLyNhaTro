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
        
        .breadcrumb {
            background: white;
            border-radius: 10px;
            padding: 15px 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .breadcrumb-item + .breadcrumb-item::before {
            content: "›";
        }
        
        .user-avatar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            width: 100px;
            height: 100px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 2.5rem;
            margin: 0 auto 20px;
        }
        
        .info-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 25px;
        }
        
        .info-row {
            padding: 12px 0;
            border-bottom: 1px solid #f8f9fa;
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 600;
            color: #667eea;
            margin-bottom: 5px;
        }
        
        .badge-user {
            background: #28a745;
        }
        
        .badge-admin {
            background: #dc3545;
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
                
                <!-- User Detail Content -->
                <div class="p-4">
                    <!-- Breadcrumb -->
                    <nav aria-label="breadcrumb" class="mb-4">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/admin/dashboard">
                                    <i class="bi bi-house"></i> Trang chủ
                                </a>
                            </li>
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/admin/users">Quản lý Người dùng</a>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page">Chi tiết người dùng</li>
                        </ol>
                    </nav>
                    
                    <!-- User Profile Card -->
                    <div class="info-card">
                        <div class="text-center">
                            <div class="user-avatar">
                                ${targetUser.fullName.substring(0, 1).toUpperCase()}
                            </div>
                            <h3>${targetUser.fullName}</h3>
                            <c:choose>
                                <c:when test="${targetUser.role == 'ADMIN'}">
                                    <span class="badge badge-admin fs-6">Quản trị viên</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-user fs-6">Người dùng</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <!-- User Information -->
                    <div class="row">
                        <div class="col-md-8">
                            <div class="info-card">
                                <h5 class="mb-4">
                                    <i class="bi bi-person-vcard me-2"></i>
                                    Thông tin cá nhân
                                </h5>
                                
                                <div class="info-row">
                                    <div class="info-label">ID Người dùng</div>
                                    <div>${targetUser.userId}</div>
                                </div>
                                
                                <div class="info-row">
                                    <div class="info-label">Tên đăng nhập</div>
                                    <div><strong>${targetUser.username}</strong></div>
                                </div>
                                
                                <div class="info-row">
                                    <div class="info-label">Họ tên đầy đủ</div>
                                    <div>${targetUser.fullName}</div>
                                </div>
                                
                                <div class="info-row">
                                    <div class="info-label">Email</div>
                                    <div>
                                        <c:choose>
                                            <c:when test="${not empty targetUser.email}">
                                                <a href="mailto:${targetUser.email}">
                                                    <i class="bi bi-envelope me-1"></i>
                                                    ${targetUser.email}
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Chưa cập nhật</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                
                                <div class="info-row">
                                    <div class="info-label">Số điện thoại</div>
                                    <div>
                                        <c:choose>
                                            <c:when test="${not empty targetUser.phone}">
                                                <a href="tel:${targetUser.phone}">
                                                    <i class="bi bi-telephone me-1"></i>
                                                    ${targetUser.phone}
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Chưa cập nhật</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                
                                <div class="info-row">
                                    <div class="info-label">Địa chỉ</div>
                                    <div>
                                        <c:choose>
                                            <c:when test="${not empty targetUser.address}">
                                                <i class="bi bi-geo-alt me-1"></i>
                                                ${targetUser.address}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Chưa cập nhật</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                
                                <div class="info-row">
                                    <div class="info-label">Ngày tạo tài khoản</div>
                                    <div>
                                        <i class="bi bi-calendar me-1"></i>
                                        <fmt:formatDate value="${targetUser.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-4">
                            <!-- Actions Card -->
                            <div class="info-card">
                                <h5 class="mb-4">
                                    <i class="bi bi-gear me-2"></i>
                                    Thao tác
                                </h5>
                                
                                <div class="d-grid gap-2">
                                    <a href="${pageContext.request.contextPath}/admin/users" 
                                       class="btn btn-outline-secondary">
                                        <i class="bi bi-arrow-left me-2"></i>
                                        Quay lại danh sách
                                    </a>
                                    
                                    <c:if test="${targetUser.role != 'ADMIN'}">
                                        <c:choose>
                                            <c:when test="${canDelete}">
                                                <button type="button" 
                                                        class="btn btn-danger"
                                                        onclick="confirmDelete(${targetUser.userId}, '${targetUser.fullName}')">
                                                    <i class="bi bi-trash me-2"></i>
                                                    Xóa người dùng
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <button type="button" class="btn btn-danger" disabled 
                                                        title="Không thể xóa người dùng đang thuê trọ">
                                                    <i class="bi bi-shield-x me-2"></i>
                                                    Không thể xóa
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                </div>
                            </div>
                            
                            <!-- Status Card -->
                            <div class="info-card">
                                <h5 class="mb-4">
                                    <i class="bi bi-info-circle me-2"></i>
                                    Trạng thái
                                </h5>
                                
                                <div class="info-row">
                                    <div class="info-label">Vai trò</div>
                                    <div>
                                        <c:choose>
                                            <c:when test="${targetUser.role == 'ADMIN'}">
                                                <span class="badge badge-admin">Quản trị viên</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-user">Người dùng thường</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                
                                <div class="info-row">
                                    <div class="info-label">Có thể xóa</div>
                                    <div>
                                        <c:choose>
                                            <c:when test="${canDelete && targetUser.role != 'ADMIN'}">
                                                <span class="badge bg-success">Có</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning text-dark">Không</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                
                                <div class="info-row">
                                    <div class="info-label">Trạng thái tài khoản</div>
                                    <div>
                                        <span class="badge bg-success">Hoạt động</span>
                                    </div>
                                </div>
                            </div>
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
