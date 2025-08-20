<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
        }
        
        .sidebar .nav-link {
            color: rgba(255,255,255,0.8);
            border-radius: 10px;
            margin: 2px 0;
        }
        
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            background: rgba(255,255,255,0.2);
            color: white;
        }
        
        .main-content {
            background-color: #f8f9fa;
            min-height: 100vh;
        }
        
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        
        .invoice-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px 15px 0 0;
        }
        
        .invoice-info {
            background: linear-gradient(135deg, #e3f2fd, #f3e5f5);
            border-radius: 10px;
            border-left: 4px solid #667eea;
        }
        
        .cost-breakdown-card {
            border: 2px solid #e9ecef;
            border-radius: 12px;
            transition: all 0.3s ease;
        }
        
        .cost-breakdown-card:hover {
            border-color: #667eea;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.15);
        }
        
        .badge-paid {
            background: linear-gradient(135deg, #28a745, #20c997);
        }
        
        .badge-unpaid {
            background: linear-gradient(135deg, #dc3545, #fd7e14);
        }
        
        .btn-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 10px;
            color: white;
        }
        
        .btn-custom:hover {
            background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
            color: white;
        }
        
        .total-amount {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            border-radius: 10px;
        }
        
        .service-item, .additional-cost-item {
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 3px solid #667eea;
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/bills">
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
            <div class="col-md-9 col-lg-10 main-content p-4">
                <!-- Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2><i class="bi bi-file-text me-2"></i>${pageTitle}</h2>
                        <p class="text-muted mb-0">Chi tiết hóa đơn và phí tổng hợp</p>
                    </div>
                    <div class="text-end">
                        <span class="text-muted">Xin chào, </span>
                        <strong>${user.fullName}</strong>
                    </div>
                </div>
                
                <!-- Success/Error Messages -->
                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i>${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <!-- Invoice Detail -->
                <div class="row">
                    <div class="col-md-8">
                        <!-- Invoice Header -->
                        <div class="card mb-4">
                            <div class="invoice-header p-4">
                                <div class="row align-items-center">
                                    <div class="col-md-6">
                                        <h3 class="mb-1">HÓA ĐƠN #${invoice.invoiceId}</h3>
                                        <p class="mb-0 opacity-75">Kỳ thanh toán: ${invoice.formattedPeriod}</p>
                                    </div>
                                    <div class="col-md-6 text-end">
                                        <c:choose>
                                            <c:when test="${invoice.status == 'PAID'}">
                                                <span class="badge badge-paid fs-6 px-3 py-2">
                                                    <i class="bi bi-check-circle me-1"></i>Đã thanh toán
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-unpaid fs-6 px-3 py-2">
                                                    <i class="bi bi-exclamation-circle me-1"></i>Chưa thanh toán
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Invoice Info -->
                            <div class="card-body">
                                <div class="invoice-info p-3 mb-4">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <h6 class="text-primary mb-2"><i class="bi bi-people me-1"></i>Thông tin người thuê</h6>
                                            <c:choose>
                                                <c:when test="${fn:length(tenantsInRoom) > 1}">
                                                    <p class="mb-1"><strong>Số người thuê:</strong> ${fn:length(tenantsInRoom)} người</p>
                                                    <div class="mb-2">
                                                        <strong>Danh sách:</strong><br>
                                                        <c:forEach var="roomTenant" items="${tenantsInRoom}" varStatus="status">
                                                            <small class="text-muted">
                                                                <i class="bi bi-person me-1"></i>${roomTenant.fullName}
                                                                <c:if test="${not empty roomTenant.phone}"> - ${roomTenant.phone}</c:if>
                                                                <c:if test="${!status.last}"><br></c:if>
                                                            </small>
                                                        </c:forEach>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <p class="mb-1"><strong>Họ tên:</strong> ${invoice.tenantName}</p>
                                                    <p class="mb-1"><strong>Số điện thoại:</strong> ${invoice.userPhone}</p>
                                                    <p class="mb-0"><strong>Email:</strong> ${invoice.userEmail}</p>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="col-md-6">
                                            <h6 class="text-primary mb-2"><i class="bi bi-door-open me-1"></i>Thông tin phòng</h6>
                                            <p class="mb-1"><strong>Phòng:</strong> ${invoice.roomName}</p>
                                            <p class="mb-1"><strong>Ngày tạo HĐ:</strong> 
                                                <fmt:formatDate value="${invoice.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </p>
                                            <p class="mb-1"><strong>Mã hóa đơn:</strong> #${invoice.invoiceId}</p>
                                            <c:if test="${invoice.hasMomoQrCode()}">
                                                <p class="mb-0">
                                                    <strong>MoMo:</strong> 
                                                    <c:choose>
                                                        <c:when test="${invoice.isMomoPending()}">
                                                            <span class="badge bg-warning text-dark">
                                                                <i class="bi bi-clock me-1"></i>Chờ thanh toán
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${invoice.isMomoPaid()}">
                                                            <span class="badge bg-success">
                                                                <i class="bi bi-check-circle me-1"></i>Đã thanh toán
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${invoice.isMomoFailed()}">
                                                            <span class="badge bg-danger">
                                                                <i class="bi bi-x-circle me-1"></i>Thất bại
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">
                                                                <i class="bi bi-qr-code me-1"></i>Có QR Code
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Cost Breakdown -->
                                <div class="row">
                                    <!-- Room Cost -->
                                    <div class="col-md-4 mb-3">
                                        <div class="cost-breakdown-card p-3 h-100">
                                            <div class="d-flex align-items-center mb-2">
                                                <i class="bi bi-house fs-3 text-primary me-2"></i>
                                                <div>
                                                    <h6 class="mb-0">Tiền phòng</h6>
                                                    <c:choose>
                                                        <c:when test="${isProrated}">
                                                            <small class="text-muted">Tính theo tỷ lệ ngày ở</small>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <small class="text-muted">Phí cơ bản hàng tháng</small>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                            <h4 class="text-primary mb-0">
                                                <fmt:formatNumber value="${invoice.roomPrice}" type="number" maxFractionDigits="0"/> VNĐ
                                            </h4>
                                            <c:if test="${isProrated}">
                                                <small class="text-info">
                                                    <i class="bi bi-calendar-check me-1"></i>
                                                    ${daysStayed}/${daysInMonth} ngày
                                                    <c:if test="${earliestStartDate != null}">
                                                        <br>(từ <fmt:formatDate value="${earliestStartDate}" pattern="dd/MM/yyyy"/>)
                                                    </c:if>
                                                </small>
                                            </c:if>
                                        </div>
                                    </div>
                                    
                                    <!-- Service Cost -->
                                    <div class="col-md-4 mb-3">
                                        <div class="cost-breakdown-card p-3 h-100">
                                            <div class="d-flex align-items-center mb-2">
                                                <i class="bi bi-tools fs-3 text-info me-2"></i>
                                                <div>
                                                    <h6 class="mb-0">Tiền dịch vụ</h6>
                                                    <small class="text-muted">Điện, nước, internet...</small>
                                                </div>
                                            </div>
                                            <h4 class="text-info mb-0">
                                                <fmt:formatNumber value="${invoice.serviceTotal}" type="number" maxFractionDigits="0"/> VNĐ
                                            </h4>
                                        </div>
                                    </div>
                                    
                                    <!-- Additional Cost -->
                                    <div class="col-md-4 mb-3">
                                        <div class="cost-breakdown-card p-3 h-100">
                                            <div class="d-flex align-items-center mb-2">
                                                <i class="bi bi-plus-circle fs-3 text-warning me-2"></i>
                                                <div>
                                                    <h6 class="mb-0">Chi phí phát sinh</h6>
                                                    <small class="text-muted">Sửa chữa, vệ sinh...</small>
                                                </div>
                                            </div>
                                            <h4 class="text-warning mb-0">
                                                <fmt:formatNumber value="${invoice.additionalTotal}" type="number" maxFractionDigits="0"/> VNĐ
                                            </h4>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Service Usage Details -->
                        <c:if test="${not empty serviceUsages}">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h5 class="mb-0"><i class="bi bi-graph-up me-2"></i>Chi tiết Sử dụng Dịch vụ</h5>
                                    <c:if test="${fn:length(tenantsInRoom) > 1}">
                                        <small class="text-muted">
                                            <i class="bi bi-info-circle me-1"></i>
                                            Số liệu đã được tổng hợp cho tất cả ${fn:length(tenantsInRoom)} người thuê trong phòng
                                        </small>
                                    </c:if>
                                </div>
                                <div class="card-body">
                                    <c:forEach var="serviceUsage" items="${serviceUsages}">
                                        <div class="service-item p-3 mb-2">
                                            <div class="row align-items-center">
                                                <div class="col-md-4">
                                                    <h6 class="mb-1">${serviceUsage.serviceName}</h6>
                                                    <small class="text-muted">Đơn vị: ${serviceUsage.serviceUnit}</small>
                                                    <c:if test="${fn:length(tenantsInRoom) > 1}">
                                                        <br><small class="text-info">
                                                            <i class="bi bi-people me-1"></i>Tổng hợp cho ${fn:length(tenantsInRoom)} người thuê
                                                        </small>
                                                    </c:if>
                                                </div>
                                                <div class="col-md-2 text-center">
                                                    <strong>${serviceUsage.quantity}</strong><br>
                                                    <small class="text-muted">
                                                        ${serviceUsage.serviceUnit}
                                                        <c:if test="${fn:length(tenantsInRoom) > 1}">
                                                            <br>(Tổng cộng)
                                                        </c:if>
                                                    </small>
                                                </div>
                                                <div class="col-md-3 text-center">
                                                    <fmt:formatNumber value="${serviceUsage.pricePerUnit}" type="number" maxFractionDigits="0"/> VNĐ<br>
                                                    <small class="text-muted">/${serviceUsage.serviceUnit}</small>
                                                </div>
                                                <div class="col-md-3 text-end">
                                                    <strong class="text-primary">
                                                        <fmt:formatNumber value="${serviceUsage.totalCost}" type="number" maxFractionDigits="0"/> VNĐ
                                                    </strong>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>
                        
                        <!-- Additional Costs Details -->
                        <c:if test="${not empty additionalCosts}">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h5 class="mb-0"><i class="bi bi-plus-circle me-2"></i>Chi tiết Chi phí Phát sinh</h5>
                                </div>
                                <div class="card-body">
                                    <c:forEach var="cost" items="${additionalCosts}">
                                        <div class="additional-cost-item p-3 mb-2">
                                            <div class="row align-items-center">
                                                <div class="col-md-6">
                                                    <h6 class="mb-1">${cost.description}</h6>
                                                    <small class="text-muted">
                                                        <i class="bi bi-calendar me-1"></i>
                                                        <fmt:formatDate value="${cost.date}" pattern="dd/MM/yyyy"/>
                                                    </small>
                                                </div>
                                                <div class="col-md-6 text-end">
                                                    <strong class="text-warning">
                                                        <fmt:formatNumber value="${cost.amount}" type="number" maxFractionDigits="0"/> VNĐ
                                                    </strong>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>
                    </div>
                    
                    <!-- Actions Sidebar -->
                    <div class="col-md-4">
                        <!-- Total Amount -->
                        <div class="card total-amount mb-4">
                            <div class="card-body text-center">
                                <h5 class="mb-2">TỔNG TIỀN</h5>
                                <h2 class="mb-3">
                                    <fmt:formatNumber value="${invoice.totalAmount}" type="number" maxFractionDigits="0"/> VNĐ
                                </h2>
                                <p class="mb-0 opacity-75">
                                    Kỳ thanh toán: ${invoice.formattedPeriod}<br>
                                    <c:if test="${isProrated}">
                                        <small class="text-warning">
                                            <i class="bi bi-info-circle me-1"></i>
                                            Tiền phòng tính theo ${daysStayed}/${daysInMonth} ngày
                                        </small><br>
                                    </c:if>
                                    <small>Đã bao gồm tất cả các phí</small>
                                </p>
                            </div>
                        </div>
                        
                        
                        <!-- Actions -->
                        <div class="card">
                            <div class="card-header">
                                <h6 class="mb-0"><i class="bi bi-gear me-2"></i>Thao tác</h6>
                            </div>
                            <div class="card-body">
                                <!-- Update Status -->
                                <div class="mb-3">
                                    <label class="form-label">Cập nhật trạng thái:</label>
                                    <div class="d-grid gap-2">
                                        <c:if test="${invoice.status != 'PAID'}">
                                            <form method="POST" action="${pageContext.request.contextPath}/admin/bills/update-status/${invoice.invoiceId}" style="display: inline;">
                                                <input type="hidden" name="status" value="PAID">
                                                <button type="submit" class="btn btn-success w-100">
                                                    <i class="bi bi-check-circle me-2"></i>Đánh dấu đã thanh toán
                                                </button>
                                            </form>
                                        </c:if>
                                        
                                        <c:if test="${invoice.status != 'UNPAID'}">
                                            <form method="POST" action="${pageContext.request.contextPath}/admin/bills/update-status/${invoice.invoiceId}" style="display: inline;">
                                                <input type="hidden" name="status" value="UNPAID">
                                                <button type="submit" class="btn btn-warning w-100">
                                                    <i class="bi bi-exclamation-circle me-2"></i>Đánh dấu chưa thanh toán
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </div>
                                
                                <hr>
                                
                                <!-- Navigation -->
                                <div class="d-grid gap-2">
                                    <a href="${pageContext.request.contextPath}/admin/bills" class="btn btn-custom">
                                        <i class="bi bi-arrow-left me-2"></i>Về danh sách
                                    </a>
                                    
                                    <button type="button" class="btn btn-outline-danger" onclick="confirmDelete(${invoice.invoiceId})">
                                        <i class="bi bi-trash me-2"></i>Xóa hóa đơn
                                    </button>
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
                    <h5 class="modal-title">Xác nhận xóa hóa đơn</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="text-center mb-3">
                        <i class="bi bi-exclamation-triangle text-warning fs-1"></i>
                    </div>
                    <p class="text-center">Bạn có chắc chắn muốn xóa hóa đơn #${invoice.invoiceId}?</p>
                    <p class="text-center text-muted">
                        <strong>Lưu ý:</strong> Thao tác này không thể hoàn tác và sẽ xóa vĩnh viễn tất cả dữ liệu liên quan!
                    </p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <form method="POST" style="display: inline;" id="deleteForm">
                        <button type="submit" class="btn btn-danger">
                            <i class="bi bi-trash me-2"></i>Xóa hóa đơn
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmDelete(invoiceId) {
            const form = document.getElementById('deleteForm');
            form.action = '${pageContext.request.contextPath}/admin/bills/delete/' + invoiceId;
            
            const modal = new bootstrap.Modal(document.getElementById('deleteModal'));
            modal.show();
        }
    </script>
</body>
</html>
