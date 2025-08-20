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
        
        .info-item {
            border-bottom: 1px solid #eee;
            padding: 15px 0;
        }
        
        .info-item:last-child {
            border-bottom: none;
        }
        
        .service-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
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
                
                <!-- Service Detail Content -->
                <div class="p-4">
                    <!-- Breadcrumb -->
                    <nav aria-label="breadcrumb" class="mb-4">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/admin/dashboard">Bảng điều khiển</a>
                            </li>
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/admin/services">Quản lý Dịch vụ</a>
                            </li>
                            <li class="breadcrumb-item active">${service.serviceName}</li>
                        </ol>
                    </nav>
                    
                    <!-- Service Information Card -->
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">
                                <i class="bi bi-info-circle me-2"></i>
                                Thông tin Dịch vụ: ${service.serviceName}
                            </h5>
                            <span class="badge bg-light text-dark fs-6">#${service.serviceId}</span>
                        </div>
                        <div class="card-body">
                            <!-- Service Header -->
                            <div class="row mb-4">
                                <div class="col-md-2 text-center">
                                    <div class="service-icon mx-auto">
                                        <i class="bi bi-tools"></i>
                                    </div>
                                </div>
                                <div class="col-md-10">
                                    <h3 class="mb-2">${service.serviceName}</h3>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <p class="text-muted mb-1">
                                                <i class="bi bi-rulers me-1"></i>
                                                <strong>Đơn vị:</strong> 
                                                <c:choose>
                                                    <c:when test="${not empty service.unit}">
                                                        ${service.unit}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <em>Không có đơn vị</em>
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                        </div>
                                        <div class="col-md-6">
                                            <p class="text-success mb-1 fs-5">
                                                <i class="bi bi-currency-dollar me-1"></i>
                                                <strong>
                                                    <fmt:formatNumber value="${service.pricePerUnit}" 
                                                                    type="currency" 
                                                                    currencySymbol="₫" 
                                                                    groupingUsed="true"/>
                                                    <c:if test="${not empty service.unit}">/${service.unit}</c:if>
                                                </strong>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Service Details -->
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <div class="info-item">
                                        <div class="row">
                                            <div class="col-4">
                                                <strong><i class="bi bi-hash me-2"></i>Mã Dịch vụ:</strong>
                                            </div>
                                            <div class="col-8">
                                                <span class="text-muted">#${service.serviceId}</span>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="info-item">
                                        <div class="row">
                                            <div class="col-4">
                                                <strong><i class="bi bi-tools me-2"></i>Tên Dịch vụ:</strong>
                                            </div>
                                            <div class="col-8">
                                                <span class="fs-5">${service.serviceName}</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="info-item">
                                        <div class="row">
                                            <div class="col-4">
                                                <strong><i class="bi bi-rulers me-2"></i>Đơn vị tính:</strong>
                                            </div>
                                            <div class="col-8">
                                                <c:choose>
                                                    <c:when test="${not empty service.unit}">
                                                        <span class="badge bg-secondary">${service.unit}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Không có đơn vị</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="info-item">
                                        <div class="row">
                                            <div class="col-4">
                                                <strong><i class="bi bi-currency-dollar me-2"></i>Giá/Đơn vị:</strong>
                                            </div>
                                            <div class="col-8">
                                                <span class="fs-5 text-success">
                                                    <fmt:formatNumber value="${service.pricePerUnit}" 
                                                                    type="currency" 
                                                                    currencySymbol="₫" 
                                                                    groupingUsed="true"/>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Action Buttons -->
                            <div class="d-flex justify-content-between">
                                <a href="${pageContext.request.contextPath}/admin/services" 
                                   class="btn btn-secondary">
                                    <i class="bi bi-arrow-left me-1"></i>
                                    Quay lại Danh sách
                                </a>
                                
                                <div class="btn-group">
                                    <a href="${pageContext.request.contextPath}/admin/services/edit/${service.serviceId}" 
                                       class="btn btn-primary">
                                        <i class="bi bi-pencil me-1"></i>
                                        Chỉnh sửa
                                    </a>
                                    
                                    <c:choose>
                                        <c:when test="${canDelete}">
                                            <button type="button" 
                                                    class="btn btn-outline-danger" 
                                                    onclick="confirmDelete(${service.serviceId}, '${service.serviceName}')">
                                                <i class="bi bi-trash me-1"></i>
                                                Xóa Dịch vụ
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="button" 
                                                    class="btn btn-outline-secondary" 
                                                    disabled 
                                                    title="Không thể xóa dịch vụ đang được sử dụng">
                                                <i class="bi bi-trash me-1"></i>
                                                Không thể xóa
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
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
                                    <h6 class="text-muted">Tình trạng sử dụng</h6>
                                    <c:choose>
                                        <c:when test="${!canDelete}">
                                            <p class="text-warning">
                                                <i class="bi bi-exclamation-triangle me-1"></i>
                                                Dịch vụ đang được sử dụng
                                            </p>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-success">
                                                <i class="bi bi-check-circle me-1"></i>
                                                Dịch vụ chưa được sử dụng
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
                                                Dịch vụ có lịch sử sử dụng, không thể xóa
                                            </p>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-muted">
                                                <i class="bi bi-check-circle me-1"></i>
                                                Dịch vụ có thể được xóa
                                            </p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Usage Examples Card -->
                    <div class="card mt-4">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="bi bi-calculator me-2"></i>
                                Ví dụ tính toán
                            </h5>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${not empty service.unit}">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="text-center p-3 bg-light rounded">
                                                <h6>Sử dụng 10 ${service.unit}</h6>
                                                <p class="text-success fw-bold mb-0">
                                                    <fmt:formatNumber value="${service.pricePerUnit * 10}" 
                                                                    type="currency" 
                                                                    currencySymbol="₫" 
                                                                    groupingUsed="true"/>
                                                </p>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="text-center p-3 bg-light rounded">
                                                <h6>Sử dụng 50 ${service.unit}</h6>
                                                <p class="text-success fw-bold mb-0">
                                                    <fmt:formatNumber value="${service.pricePerUnit * 50}" 
                                                                    type="currency" 
                                                                    currencySymbol="₫" 
                                                                    groupingUsed="true"/>
                                                </p>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="text-center p-3 bg-light rounded">
                                                <h6>Sử dụng 100 ${service.unit}</h6>
                                                <p class="text-success fw-bold mb-0">
                                                    <fmt:formatNumber value="${service.pricePerUnit * 100}" 
                                                                    type="currency" 
                                                                    currencySymbol="₫" 
                                                                    groupingUsed="true"/>
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center text-muted">
                                        <p>Dịch vụ này không có đơn vị tính cụ thể.</p>
                                        <p>Giá cố định: 
                                            <span class="text-success fw-bold">
                                                <fmt:formatNumber value="${service.pricePerUnit}" 
                                                                type="currency" 
                                                                currencySymbol="₫" 
                                                                groupingUsed="true"/>
                                            </span>
                                        </p>
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
