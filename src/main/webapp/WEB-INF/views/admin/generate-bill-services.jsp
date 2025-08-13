<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .sidebar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            width: 250px;
            z-index: 1000;
        }
        .main-content {
            margin-left: 250px;
            padding: 20px;
            background-color: #f8f9fa;
            min-height: 100vh;
        }
        .bill-summary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 25px;
        }
        .service-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            margin-bottom: 15px;
            transition: transform 0.2s;
        }
        .service-card:hover {
            transform: translateY(-2px);
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 10px;
        }
        .btn-secondary {
            border-radius: 10px;
        }
        .quantity-input {
            text-align: right;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="text-center py-4">
            <i class="bi bi-building-gear fs-1 text-white"></i>
            <h4 class="text-white mt-2">Admin Panel</h4>
            <p class="text-white-50 mb-0">${user.fullName}</p>
            <small class="text-white-50">Quản trị viên</small>
        </div>
        
        <nav class="mt-4">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link text-white px-4 py-3">
                <i class="bi bi-speedometer2 me-2"></i> Bảng điều khiển
            </a>
            <a href="${pageContext.request.contextPath}/admin/users" class="nav-link text-white px-4 py-3">
                <i class="bi bi-people me-2"></i> Quản lý Người dùng
            </a>
            <a href="${pageContext.request.contextPath}/admin/rooms" class="nav-link text-white px-4 py-3">
                <i class="bi bi-door-open me-2"></i> Quản lý Phòng trọ
            </a>
            <a href="${pageContext.request.contextPath}/admin/services" class="nav-link text-white px-4 py-3">
                <i class="bi bi-gear me-2"></i> Quản lý Dịch vụ
            </a>
            <a href="${pageContext.request.contextPath}/admin/tenants" class="nav-link text-white px-4 py-3">
                <i class="bi bi-person-check me-2"></i> Quản lý Thuê trọ
            </a>
            <a href="${pageContext.request.contextPath}/admin/bills" class="nav-link text-white px-4 py-3 active" style="background: rgba(255,255,255,0.1);">
                <i class="bi bi-receipt me-2"></i> Quản lý Hóa đơn
            </a>
            <a href="${pageContext.request.contextPath}/admin/reports" class="nav-link text-white px-4 py-3">
                <i class="bi bi-bar-chart me-2"></i> Báo cáo & Thống kê
            </a>
            <hr class="text-white-50 mx-3">
            <a href="${pageContext.request.contextPath}/logout" class="nav-link text-white px-4 py-3">
                <i class="bi bi-box-arrow-right me-2"></i> Đăng xuất
            </a>
        </nav>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="bi bi-receipt-cutoff me-2"></i> ${pageTitle}</h2>
        </div>

        <!-- Bill Summary -->
        <div class="bill-summary">
            <div class="row">
                <div class="col-md-3">
                    <h6>Người thuê:</h6>
                    <h5>${tenant.fullName}</h5>
                    <small>ID: #${tenant.tenantId}</small>
                </div>
                <div class="col-md-3">
                    <h6>Phòng:</h6>
                    <h5>${room.roomName}</h5>
                    <small>Giá phòng: <fmt:formatNumber value="${room.price}" pattern="#,##0" /> VNĐ</small>
                </div>
                <div class="col-md-3">
                    <h6>Kỳ thanh toán:</h6>
                    <h5><fmt:formatNumber value="${month}" minIntegerDigits="2"/>/${year}</h5>
                </div>
                <div class="col-md-3">
                    <h6>Chi phí phát sinh:</h6>
                    <h5><fmt:formatNumber value="${additionalTotal}" pattern="#,##0" /> VNĐ</h5>
                    <small>${fn:length(additionalCosts)} khoản phát sinh</small>
                </div>
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/admin/bills/generate/final" method="post">
            <input type="hidden" name="tenantId" value="${tenantId}">
            <input type="hidden" name="month" value="${month}">
            <input type="hidden" name="year" value="${year}">

            <!-- Service Usage Input -->
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0"><i class="bi bi-gear-fill me-2"></i>Nhập sử dụng dịch vụ</h5>
                    <small class="text-muted">Nhập số lượng sử dụng cho từng dịch vụ trong tháng ${month}/${year}</small>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty services}">
                            <div class="alert alert-info mb-3">
                                <i class="bi bi-info-circle me-2"></i>
                                <strong>Dịch vụ có sẵn cho ${tenant.fullName}:</strong>
                                Hiển thị các dịch vụ mà người thuê này đã sử dụng trước đây. 
                                <c:if test="${fn:length(services) < 10}">Nếu cần thêm dịch vụ mới, vui lòng liên hệ quản trị viên.</c:if>
                            </div>
                            <div class="row">
                                <c:forEach var="service" items="${services}" varStatus="status">
                                    <div class="col-md-6 col-lg-4">
                                        <div class="service-card card h-100">
                                            <div class="card-body">
                                                <input type="hidden" name="serviceIds" value="${service.serviceId}">
                                                
                                                <h6 class="card-title">
                                                    <i class="bi bi-lightning-charge me-2"></i>
                                                    ${service.serviceName}
                                                </h6>
                                                
                                                <div class="mb-3">
                                                    <small class="text-muted">
                                                        Đơn giá: <strong><fmt:formatNumber value="${service.pricePerUnit}" pattern="#,##0" /> VNĐ/${service.unit}</strong>
                                                    </small>
                                                </div>
                                                
                                                <div class="mb-3">
                                                    <label class="form-label small">Số lượng sử dụng (${service.unit})</label>
                                                    <c:set var="existingQuantity" value="0" />
                                                    <c:forEach var="usage" items="${existingUsages}">
                                                        <c:if test="${usage.serviceId == service.serviceId}">
                                                            <c:set var="existingQuantity" value="${usage.quantity}" />
                                                        </c:if>
                                                    </c:forEach>
                                                    
                                                    <input type="number" 
                                                           class="form-control quantity-input" 
                                                           name="quantities" 
                                                           value="${existingQuantity}"
                                                           min="0" 
                                                           step="0.01" 
                                                           placeholder="0.00"
                                                           data-price="${service.pricePerUnit}"
                                                           data-service="${service.serviceName}"
                                                           onchange="calculateServiceCost(this)">
                                                </div>
                                                
                                                <div class="text-end">
                                                    <small class="text-muted">Thành tiền:</small>
                                                    <div class="service-cost h6 text-primary" id="cost-${service.serviceId}">
                                                        <fmt:formatNumber value="${existingQuantity * service.pricePerUnit}" pattern="#,##0" /> VNĐ
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-4">
                                <i class="bi bi-info-circle fs-1 text-muted"></i>
                                <h5 class="text-muted mt-3">Chưa có dịch vụ nào cho ${tenant.fullName}</h5>
                                <p class="text-muted">Người thuê này chưa sử dụng dịch vụ nào. Bạn có thể:</p>
                                <ul class="list-unstyled text-muted">
                                    <li><i class="bi bi-arrow-right me-2"></i>Thêm dữ liệu sử dụng dịch vụ trước đây qua <a href="${pageContext.request.contextPath}/admin/service-usage/add">Quản lý Sử dụng Dịch vụ</a></li>
                                    <li><i class="bi bi-arrow-right me-2"></i>Hoặc tạo hóa đơn chỉ với tiền phòng và chi phí phát sinh</li>
                                </ul>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Bill Preview -->
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0"><i class="bi bi-calculator me-2"></i>Xem trước hóa đơn</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-8">
                            <table class="table table-borderless">
                                <tr>
                                    <td>Tiền phòng:</td>
                                    <td class="text-end"><fmt:formatNumber value="${room.price}" pattern="#,##0" /> VNĐ</td>
                                </tr>
                                <tr>
                                    <td>Tiền dịch vụ:</td>
                                    <td class="text-end" id="total-service-cost">0 VNĐ</td>
                                </tr>
                                <tr>
                                    <td>Chi phí phát sinh:</td>
                                    <td class="text-end"><fmt:formatNumber value="${additionalTotal}" pattern="#,##0" /> VNĐ</td>
                                </tr>
                                <tr class="border-top">
                                    <th>Tổng tiền:</th>
                                    <th class="text-end text-primary h5" id="grand-total">
                                        <fmt:formatNumber value="${room.price + additionalTotal}" pattern="#,##0" /> VNĐ
                                    </th>
                                </tr>
                            </table>
                        </div>
                        <div class="col-md-4">
                            <c:if test="${not empty additionalCosts}">
                                <h6>Chi phí phát sinh:</h6>
                                <c:forEach var="cost" items="${additionalCosts}">
                                    <div class="d-flex justify-content-between small">
                                        <span>${cost.description}</span>
                                        <span><fmt:formatNumber value="${cost.amount}" pattern="#,##0" /> VNĐ</span>
                                    </div>
                                </c:forEach>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="d-flex justify-content-between">
                <a href="${pageContext.request.contextPath}/admin/bills/generate" class="btn btn-secondary">
                    <i class="bi bi-arrow-left me-2"></i>Quay lại
                </a>
                <button type="submit" class="btn btn-primary btn-lg">
                    <i class="bi bi-check-circle me-2"></i>Tạo hóa đơn
                </button>
            </div>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const roomPrice = ${room.price};
        const additionalTotal = ${additionalTotal};
        
        function calculateServiceCost(input) {
            const quantity = parseFloat(input.value) || 0;
            const pricePerUnit = parseFloat(input.dataset.price) || 0;
            const serviceId = input.closest('.card').querySelector('input[name="serviceIds"]').value;
            const cost = quantity * pricePerUnit;
            
            // Update individual service cost display
            const costElement = document.getElementById('cost-' + serviceId);
            if (costElement) {
                costElement.textContent = new Intl.NumberFormat('vi-VN').format(cost) + ' VNĐ';
            }
            
            updateTotalServiceCost();
        }
        
        function updateTotalServiceCost() {
            let totalServiceCost = 0;
            
            // Calculate total service cost
            const quantityInputs = document.querySelectorAll('input[name="quantities"]');
            quantityInputs.forEach(input => {
                const quantity = parseFloat(input.value) || 0;
                const pricePerUnit = parseFloat(input.dataset.price) || 0;
                totalServiceCost += quantity * pricePerUnit;
            });
            
            // Update total service cost display
            document.getElementById('total-service-cost').textContent = 
                new Intl.NumberFormat('vi-VN').format(totalServiceCost) + ' VNĐ';
            
            // Update grand total
            const grandTotal = roomPrice + totalServiceCost + additionalTotal;
            document.getElementById('grand-total').textContent = 
                new Intl.NumberFormat('vi-VN').format(grandTotal) + ' VNĐ';
        }
        
        // Initialize calculations on page load
        document.addEventListener('DOMContentLoaded', function() {
            updateTotalServiceCost();
        });
    </script>
</body>
</html>
