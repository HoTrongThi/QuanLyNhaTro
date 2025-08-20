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
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }
        
        .table th {
            background: #f8f9fa;
            border-top: none;
            font-weight: 600;
        }
        
        .badge-primary {
            background: #667eea;
        }
        
        .service-actions {
            white-space: nowrap;
        }
        
        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
        }
        
        .search-form {
            background: white;
            border-radius: 10px;
            padding: 20px;
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                            <i class="bi bi-people me-2"></i>
                            Quản lý Người dùng
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/rooms">
                            <i class="bi bi-door-open me-2"></i>
                            Quản lý Phòng trọ
                        </a>
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/services">
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
                
                <!-- Services Management Content -->
                <div class="p-4">
                    <!-- Statistics Card -->
                    <div class="row mb-4">
                        <div class="col-md-12">
                            <div class="stats-card p-4">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <h5 class="mb-1">
                                            <i class="bi bi-tools me-2"></i>
                                            Quản lý Dịch vụ
                                        </h5>
                                        <p class="mb-0">Quản lý các dịch vụ: điện, nước, internet, và các tiện ích khác</p>
                                    </div>
                                    <div class="col-md-4 text-end">
                                        <div class="fs-1 fw-bold">${totalServices}</div>
                                        <small>Tổng số dịch vụ</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Search and Add Service -->
                    <div class="search-form mb-4">
                        <div class="row align-items-end">
                            <div class="col-md-8">
                                <form method="GET" action="${pageContext.request.contextPath}/admin/services">
                                    <div class="input-group">
                                        <input type="text" 
                                               class="form-control" 
                                               name="search" 
                                               placeholder="Tìm kiếm dịch vụ theo tên..." 
                                               value="${searchTerm}">
                                        <button class="btn btn-outline-secondary" type="submit">
                                            <i class="bi bi-search"></i>
                                        </button>
                                        <c:if test="${not empty searchTerm}">
                                            <a href="${pageContext.request.contextPath}/admin/services" 
                                               class="btn btn-outline-warning">
                                                <i class="bi bi-x-circle"></i>
                                            </a>
                                        </c:if>
                                    </div>
                                </form>
                                <c:if test="${not empty searchTerm}">
                                    <small class="text-muted mt-1 d-block">
                                        Tìm thấy ${services.size()} kết quả cho "${searchTerm}"
                                    </small>
                                </c:if>
                            </div>
                            <div class="col-md-4 text-end">
                                <a href="${pageContext.request.contextPath}/admin/services/add" 
                                   class="btn btn-primary">
                                    <i class="bi bi-plus-circle me-1"></i>
                                    Thêm Dịch vụ mới
                                </a>
                            </div>
                        </div>
                    </div>
                    
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
                    
                    <!-- Services Table -->
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="bi bi-list me-2"></i>
                                Danh sách Dịch vụ
                            </h5>
                        </div>
                        <div class="card-body p-0">
                            <c:choose>
                                <c:when test="${not empty services}">
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0">
                                            <thead>
                                                <tr>
                                                    <th width="60">#</th>
                                                    <th>Tên Dịch vụ</th>
                                                    <th width="100">Đơn vị</th>
                                                    <th width="150">Giá/Đơn vị</th>
                                                    <th width="200" class="text-center">Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="service" items="${services}" varStatus="status">
                                                    <tr>
                                                        <td class="align-middle">
                                                            <span class="badge badge-primary">${service.serviceId}</span>
                                                        </td>
                                                        <td class="align-middle">
                                                            <strong>${service.serviceName}</strong>
                                                        </td>
                                                        <td class="align-middle">
                                                            <c:choose>
                                                                <c:when test="${not empty service.unit}">
                                                                    <span class="text-muted">${service.unit}</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">-</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="align-middle">
                                                            <span class="fw-bold text-success">
                                                                <fmt:formatNumber value="${service.pricePerUnit}" 
                                                                                type="currency" 
                                                                                currencySymbol="₫" 
                                                                                groupingUsed="true"/>
                                                            </span>
                                                        </td>
                                                        <td class="align-middle service-actions text-center">
                                                            <div class="btn-group" role="group">
                                                                <a href="${pageContext.request.contextPath}/admin/services/view/${service.serviceId}" 
                                                                   class="btn btn-outline-info btn-sm" 
                                                                   title="Xem chi tiết">
                                                                    <i class="bi bi-eye"></i>
                                                                </a>
                                                                <a href="${pageContext.request.contextPath}/admin/services/edit/${service.serviceId}" 
                                                                   class="btn btn-outline-primary btn-sm" 
                                                                   title="Chỉnh sửa">
                                                                    <i class="bi bi-pencil"></i>
                                                                </a>
                                                                <button type="button" 
                                                                        class="btn btn-outline-danger btn-sm" 
                                                                        title="Xóa dịch vụ"
                                                                        onclick="confirmDelete(${service.serviceId}, '${service.serviceName}')">
                                                                    <i class="bi bi-trash"></i>
                                                                </button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-5">
                                        <i class="bi bi-tools text-muted" style="font-size: 3rem;"></i>
                                        <h5 class="text-muted mt-3">
                                            <c:choose>
                                                <c:when test="${not empty searchTerm}">
                                                    Không tìm thấy dịch vụ nào với từ khóa "${searchTerm}"
                                                </c:when>
                                                <c:otherwise>
                                                    Chưa có dịch vụ nào
                                                </c:otherwise>
                                            </c:choose>
                                        </h5>
                                        <p class="text-muted">
                                            <c:choose>
                                                <c:when test="${not empty searchTerm}">
                                                    Thử tìm kiếm với từ khóa khác hoặc 
                                                    <a href="${pageContext.request.contextPath}/admin/services">xem tất cả dịch vụ</a>
                                                </c:when>
                                                <c:otherwise>
                                                    Bắt đầu bằng cách thêm dịch vụ đầu tiên
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                        <c:if test="${empty searchTerm}">
                                            <a href="${pageContext.request.contextPath}/admin/services/add" 
                                               class="btn btn-primary">
                                                <i class="bi bi-plus-circle me-1"></i>
                                                Thêm Dịch vụ mới
                                            </a>
                                        </c:if>
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
                    <h5 class="modal-title">Xác nhận xóa dịch vụ</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn xóa dịch vụ <strong id="serviceNameToDelete"></strong>?</p>
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
        function confirmDelete(serviceId, serviceName) {
            document.getElementById('serviceNameToDelete').textContent = serviceName;
            document.getElementById('deleteForm').action = '${pageContext.request.contextPath}/admin/services/delete/' + serviceId;
            
            var deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
            deleteModal.show();
        }
    </script>
</body>
</html>
