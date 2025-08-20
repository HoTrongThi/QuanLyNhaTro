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
        
        .badge-available {
            background: #28a745;
        }
        
        .badge-occupied {
            background: #dc3545;
        }
        
        .info-item {
            border-bottom: 1px solid #eee;
            padding: 15px 0;
        }
        
        .info-item:last-child {
            border-bottom: none;
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                            <i class="bi bi-people me-2"></i>
                            Quản lý Người dùng
                        </a>
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/rooms">
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
                
                <!-- Room Detail Content -->
                <div class="p-4">
                    <!-- Breadcrumb -->
                    <nav aria-label="breadcrumb" class="mb-4">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/admin/dashboard">Bảng điều khiển</a>
                            </li>
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/admin/rooms">Quản lý Phòng trọ</a>
                            </li>
                            <li class="breadcrumb-item active">${room.roomName}</li>
                        </ol>
                    </nav>
                    
                    <!-- Room Information Card -->
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">
                                <i class="bi bi-info-circle me-2"></i>
                                Thông tin Phòng: ${room.roomName}
                            </h5>
                            <c:choose>
                                <c:when test="${room.status == 'AVAILABLE'}">
                                    <span class="badge badge-available fs-6">Có sẵn</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-occupied fs-6">Đã thuê</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="card-body">
                            <!-- Room Details -->
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <div class="info-item">
                                        <div class="row">
                                            <div class="col-4">
                                                <strong><i class="bi bi-door-closed me-2"></i>Tên Phòng:</strong>
                                            </div>
                                            <div class="col-8">
                                                <span class="fs-5">${room.roomName}</span>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="info-item">
                                        <div class="row">
                                            <div class="col-4">
                                                <strong><i class="bi bi-currency-dollar me-2"></i>Giá Phòng:</strong>
                                            </div>
                                            <div class="col-8">
                                                <span class="fs-5 text-success">
                                                    <fmt:formatNumber value="${room.price}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="info-item">
                                        <div class="row">
                                            <div class="col-4">
                                                <strong><i class="bi bi-toggle-on me-2"></i>Trạng thái:</strong>
                                            </div>
                                            <div class="col-8">
                                                <c:choose>
                                                    <c:when test="${room.status == 'AVAILABLE'}">
                                                        <span class="badge badge-available">Có sẵn</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-occupied">Đã thuê</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="info-item">
                                        <div class="row">
                                            <div class="col-4">
                                                <strong><i class="bi bi-hash me-2"></i>Mã Phòng:</strong>
                                            </div>
                                            <div class="col-8">
                                                <span class="text-muted">#${room.roomId}</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="info-item">
                                        <div class="row">
                                            <div class="col-4">
                                                <strong><i class="bi bi-card-text me-2"></i>Mô tả:</strong>
                                            </div>
                                            <div class="col-8">
                                                <c:choose>
                                                    <c:when test="${not empty room.description}">
                                                        <p class="mb-0">${room.description}</p>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Không có mô tả</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Action Buttons -->
                            <div class="d-flex justify-content-between">
                                <a href="${pageContext.request.contextPath}/admin/rooms" 
                                   class="btn btn-secondary">
                                    <i class="bi bi-arrow-left me-1"></i>
                                    Quay lại Danh sách
                                </a>
                                
                                <div class="btn-group">
                                    <a href="${pageContext.request.contextPath}/admin/rooms/edit/${room.roomId}" 
                                       class="btn btn-primary">
                                        <i class="bi bi-pencil me-1"></i>
                                        Chỉnh sửa
                                    </a>
                                    
                                    <c:if test="${canDelete}">
                                        <button type="button" 
                                                class="btn btn-outline-danger" 
                                                onclick="confirmDelete(${room.roomId}, '${room.roomName}')">
                                            <i class="bi bi-trash me-1"></i>
                                            Xóa Phòng
                                        </button>
                                    </c:if>
                                    
                                    <c:if test="${!canDelete}">
                                        <button type="button" 
                                                class="btn btn-outline-secondary" 
                                                disabled 
                                                title="Không thể xóa phòng có lịch sử thuê">
                                            <i class="bi bi-trash me-1"></i>
                                            Không thể xóa
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Additional Information Card -->
                    <div class="card mt-4">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="bi bi-info me-2"></i>
                                Thông tin bổ sung
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <h6 class="text-muted">Tình trạng thuê</h6>
                                    <c:choose>
                                        <c:when test="${room.status == 'OCCUPIED'}">
                                            <p class="text-warning">
                                                <i class="bi bi-exclamation-triangle me-1"></i>
                                                Phòng đang được thuê
                                            </p>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-success">
                                                <i class="bi bi-check-circle me-1"></i>
                                                Phòng có sẵn cho thuê
                                            </p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <div class="col-md-6">
                                    <h6 class="text-muted">Lưu ý</h6>
                                    <c:choose>
                                        <c:when test="${!canDelete}">
                                            <p class="text-info">
                                                <i class="bi bi-info-circle me-1"></i>
                                                Phòng có lịch sử thuê, không thể xóa
                                            </p>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-muted">
                                                <i class="bi bi-check-circle me-1"></i>
                                                Phòng có thể được xóa
                                            </p>
                                        </c:otherwise>
                                    </c:choose>
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
                    <h5 class="modal-title">Xác nhận xóa phòng</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn xóa phòng <strong id="roomNameToDelete"></strong>?</p>
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
        function confirmDelete(roomId, roomName) {
            document.getElementById('roomNameToDelete').textContent = roomName;
            document.getElementById('deleteForm').action = '${pageContext.request.contextPath}/admin/rooms/delete/' + roomId;
            
            var deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
            deleteModal.show();
        }
    </script>
</body>
</html>
