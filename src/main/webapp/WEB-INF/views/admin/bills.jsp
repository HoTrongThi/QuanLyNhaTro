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
        
        .table-hover tbody tr:hover {
            background-color: rgba(102, 126, 234, 0.1);
        }
        
        .badge-paid {
            background: linear-gradient(135deg, #28a745, #20c997);
        }
        
        .badge-unpaid {
            background: linear-gradient(135deg, #dc3545, #fd7e14);
        }
        
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
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
                
                <!-- Bills Content -->
                <div class="p-4">
                
                <!-- Statistics Cards -->
                <div class="row mb-4">
                    <div class="col-md-4">
                        <div class="card stat-card p-3">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="mb-1">Tổng hóa đơn</h6>
                                    <h3 class="mb-0">${totalInvoices}</h3>
                                </div>
                                <i class="bi bi-receipt fs-1 opacity-75"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card p-3" style="background: linear-gradient(135deg, #dc3545, #fd7e14); color: white;">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="mb-1">Chưa thanh toán</h6>
                                    <h3 class="mb-0">${unpaidInvoices}</h3>
                                </div>
                                <i class="bi bi-exclamation-triangle fs-1 opacity-75"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card p-3" style="background: linear-gradient(135deg, #28a745, #20c997); color: white;">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="mb-1">Tổng doanh thu</h6>
                                    <h3 class="mb-0"><fmt:formatNumber value="${totalRevenue}" type="number" maxFractionDigits="0"/> VNĐ</h3>
                                </div>
                                <i class="bi bi-cash-stack fs-1 opacity-75"></i>
                            </div>
                        </div>
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
                
                <!-- Bills Table -->
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center py-3">
                        <h5 class="mb-0"><i class="bi bi-list-ul me-2"></i>Danh sách Hóa đơn</h5>
                        <a href="${pageContext.request.contextPath}/admin/bills/generate" class="btn btn-custom">
                            <i class="bi bi-plus-lg me-2"></i>Tạo hóa đơn
                        </a>
                    </div>
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${not empty invoices}">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>ID</th>
                                                <th>Phòng</th>
                                                <th>Người thuê</th>
                                                <th>Kỳ thanh toán</th>
                                                <th>Tiền phòng</th>
                                                <th>Tiền dịch vụ</th>
                                                <th>Chi phí PS</th>
                                                <th>Tổng tiền</th>
                                                <th>Trạng thái</th>
                                                <th>Ngày tạo</th>
                                                <th class="text-center">Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="invoice" items="${invoices}">
                                                <tr>
                                                    <td><strong>#${invoice.invoiceId}</strong></td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <i class="bi bi-door-open fs-5 text-primary me-2"></i>
                                                            <div>
                                                                <div class="fw-bold">${invoice.roomName}</div>
                                                                <small class="text-muted">Hóa đơn theo phòng</small>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <i class="bi bi-people fs-6 text-secondary me-1"></i>
                                                            <div>
                                                                <div class="small">${invoice.tenantName}</div>
                                                                <small class="text-muted">
                                                                    <c:choose>
                                                                        <c:when test="${invoice.tenantsCount > 1}">
                                                                            +${invoice.tenantsCount - 1} người khác
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            (Duy nhất)
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </small>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td><strong>${invoice.formattedPeriod}</strong></td>
                                                    <td><fmt:formatNumber value="${invoice.roomPrice}" type="number" maxFractionDigits="0"/> VNĐ</td>
                                                    <td><fmt:formatNumber value="${invoice.serviceTotal}" type="number" maxFractionDigits="0"/> VNĐ</td>
                                                    <td><fmt:formatNumber value="${invoice.additionalTotal}" type="number" maxFractionDigits="0"/> VNĐ</td>
                                                    <td><strong><fmt:formatNumber value="${invoice.totalAmount}" type="number" maxFractionDigits="0"/> VNĐ</strong></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${invoice.status == 'PAID'}">
                                                                <span class="badge badge-paid">Đã thanh toán</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge badge-unpaid">Chưa thanh toán</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${invoice.createdAt}" pattern="dd/MM/yyyy"/>
                                                        <br>
                                                        <small class="text-muted">
                                                            <fmt:formatDate value="${invoice.createdAt}" pattern="HH:mm"/>
                                                        </small>
                                                    </td>
                                                    <td class="text-center">
                                                        <div class="btn-group" role="group">
                                                            <a href="${pageContext.request.contextPath}/admin/bills/view/${invoice.invoiceId}" 
                                                               class="btn btn-sm btn-outline-primary" title="Xem chi tiết">
                                                                <i class="bi bi-eye"></i>
                                                            </a>
                                                            <button type="button" class="btn btn-sm btn-outline-danger" 
                                                                    onclick="confirmDelete(${invoice.invoiceId})" title="Xóa">
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
                                    <i class="bi bi-receipt fs-1 text-muted mb-3"></i>
                                    <h5 class="text-muted">Chưa có hóa đơn nào</h5>
                                    <p class="text-muted">Nhấn "Tạo hóa đơn" để thêm hóa đơn mới</p>
                                    <a href="${pageContext.request.contextPath}/admin/bills/generate" class="btn btn-custom">
                                        <i class="bi bi-plus-lg me-2"></i>Tạo hóa đơn đầu tiên
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
    
    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Xác nhận xóa</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p><i class="bi bi-exclamation-triangle text-warning fs-3"></i></p>
                    <p>Bạn có chắc chắn muốn xóa hóa đơn này?</p>
                    <p class="text-muted"><strong>Lưu ý:</strong> Thao tác này không thể hoàn tác!</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <form method="POST" style="display: inline;" id="deleteForm">
                        <button type="submit" class="btn btn-danger">
                            <i class="bi bi-trash me-2"></i>Xóa
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
