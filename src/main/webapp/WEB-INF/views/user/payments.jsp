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
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
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
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border-radius: 15px 15px 0 0 !important;
        }
        

        
        .payment-item {
            border-radius: 12px;
            border: 2px solid #e9ecef;
            transition: all 0.3s ease;
            margin-bottom: 15px;
        }
        
        .payment-item:hover {
            border-color: #28a745;
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.15);
        }
        
        .payment-status {
            font-weight: 600;
            border-radius: 20px;
            padding: 5px 15px;
            font-size: 0.85rem;
        }
        
        .status-paid {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
        }
        
        .status-unpaid {
            background: linear-gradient(135deg, #dc3545, #fd7e14);
            color: white;
        }
        
        .filter-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            border: none;
        }
        
        .payment-date {
            color: #6c757d;
            font-size: 0.9rem;
        }
        
        .payment-amount {
            font-weight: 700;
            font-size: 1.1rem;
        }
        
        .payment-period {
            background: #e8f5e8;
            color: #28a745;
            padding: 3px 8px;
            border-radius: 8px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        
        .no-payments {
            text-align: center;
            padding: 3rem 2rem;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 15px;
        }
        
        .filter-btn {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            border-radius: 10px;
        }
        
        .filter-btn:hover {
            background: linear-gradient(135deg, #20c997 0%, #28a745 100%);
        }
        
        .summary-badge {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border-radius: 10px;
            padding: 8px 12px;
            margin: 0 5px;
            font-weight: 600;
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
                        <i class="bi bi-house-door me-2"></i>
                        Phòng trọ
                    </h4>
                    
                    <div class="text-center mb-4">
                        <div class="bg-light text-dark rounded-circle d-inline-flex align-items-center justify-content-center" 
                             style="width: 60px; height: 60px;">
                            <i class="bi bi-person-circle fs-3"></i>
                        </div>
                        <div class="mt-2">
                            <strong>${user.fullName}</strong>
                            <br>
                            <small class="text-light">Người thuê</small>
                        </div>
                    </div>
                    
                    <nav class="nav flex-column">
                        <a class="nav-link" href="${pageContext.request.contextPath}/user/dashboard">
                            <i class="bi bi-speedometer2 me-2"></i>
                            Bảng điều khiển
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/user/profile">
                            <i class="bi bi-person me-2"></i>
                            Thông tin cá nhân
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/user/room">
                            <i class="bi bi-house-door me-2"></i>
                            Thông tin Phòng
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/user/bills">
                            <i class="bi bi-receipt me-2"></i>
                            Hóa đơn của tôi
                        </a>
                        <a class="nav-link active" href="${pageContext.request.contextPath}/user/payments">
                            <i class="bi bi-credit-card me-2"></i>
                            Lịch sử Thanh toán
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/user/messages">
                            <i class="bi bi-chat-dots me-2"></i>
                            Tin nhắn
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
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/profile">Thông tin cá nhân</a></li>
                                    <li><a class="dropdown-item" href="#">Cài đặt</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </nav>

                <!-- Payment History Content -->
                <div class="p-4">
                    <!-- Header -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h4><i class="bi bi-credit-card me-2"></i>Lịch sử Thanh toán</h4>
                            <p class="text-muted mb-0">Danh sách các hóa đơn đã thanh toán của bạn</p>
                        </div>
                        <div class="d-flex gap-2">
                            <c:if test="${currentTenant != null}">
                                <span class="badge" style="background: linear-gradient(135deg, #28a745 0%, #20c997 100%); color: white; padding: 8px 12px; border-radius: 10px;">
                                    <i class="bi bi-house-door me-1"></i>${currentTenant.roomName}
                                </span>
                            </c:if>
                        </div>
                    </div>

                    <!-- Filters -->
                    <div class="card filter-card mb-4">
                        <div class="card-body">
                            <form method="GET" action="${pageContext.request.contextPath}/user/payments">
                                <div class="row align-items-end">
                                    <div class="col-md-3 mb-3 mb-md-0">
                                        <label for="yearFilter" class="form-label fw-bold">
                                            <i class="bi bi-calendar me-1"></i>Năm
                                        </label>
                                        <select id="yearFilter" name="year" class="form-select">
                                            <option value="">Tất cả</option>
                                            <c:forEach var="year" items="${availableYears}">
                                                <option value="${year}" ${filterYear == year ? 'selected' : ''}>${year}</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="col-md-6 text-md-end">
                                        <button type="submit" class="btn filter-btn me-2">
                                            <i class="bi bi-funnel me-2"></i>Lọc kết quả
                                        </button>
                                        <a href="${pageContext.request.contextPath}/user/payments" class="btn btn-outline-secondary">
                                            <i class="bi bi-arrow-clockwise me-2"></i>Xóa bộ lọc
                                        </a>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Payment List -->
                    <div class="card">
                        <div class="card-header">
                            <h6 class="mb-0">
                                <i class="bi bi-list-ul me-2"></i>
                                Danh sách Thanh toán 
                                <c:if test="${filterYear != null}">
                                    <small class="opacity-75">
                                        (${payments.size()} kết quả - Năm ${filterYear})
                                    </small>
                                </c:if>
                            </h6>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${not empty payments}">
                                    <c:forEach var="payment" items="${payments}" varStatus="status">
                                        <div class="payment-item p-4">
                                            <div class="row align-items-center">
                                                <div class="col-md-2">
                                                    <div class="text-center">
                                                        <div class="payment-period mb-2">
                                                            <i class="bi bi-calendar me-1"></i>
                                                            ${payment.formattedPeriod}
                                                        </div>
                                                        <div class="payment-date">
                                                            HĐ #${payment.invoiceId}
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="d-flex align-items-center">
                                                        <div>
                                                            <h6 class="mb-1">
                                                                <i class="bi bi-house-door me-2 text-primary"></i>
                                                                Hóa đơn phòng ${payment.roomName}
                                                            </h6>
                                                            <div class="payment-date mb-2">
                                                                <i class="bi bi-clock me-1"></i>
                                                                Tạo ngày: <fmt:formatDate value="${payment.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                            </div>
                                                            <div class="row g-0">
                                                                <div class="col-auto me-3">
                                                                    <small class="text-muted">
                                                                        <i class="bi bi-house me-1"></i>
                                                                        Phòng: <fmt:formatNumber value="${payment.roomPrice}" type="number" maxFractionDigits="0"/>₫
                                                                    </small>
                                                                </div>
                                                                <div class="col-auto me-3">
                                                                    <small class="text-muted">
                                                                        <i class="bi bi-tools me-1"></i>
                                                                        Dịch vụ: <fmt:formatNumber value="${payment.serviceTotal}" type="number" maxFractionDigits="0"/>₫
                                                                    </small>
                                                                </div>
                                                                <c:if test="${payment.additionalTotal > 0}">
                                                                    <div class="col-auto">
                                                                        <small class="text-muted">
                                                                            <i class="bi bi-plus-circle me-1"></i>
                                                                            Phát sinh: <fmt:formatNumber value="${payment.additionalTotal}" type="number" maxFractionDigits="0"/>₫
                                                                        </small>
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-2 text-center">
                                                    <c:choose>
                                                        <c:when test="${payment.status == 'PAID'}">
                                                            <span class="payment-status status-paid">
                                                                <i class="bi bi-check-circle me-1"></i>
                                                                Đã thanh toán
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="payment-status status-unpaid">
                                                                <i class="bi bi-exclamation-circle me-1"></i>
                                                                Chưa thanh toán
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="col-md-2 text-end">
                                                    <div class="payment-amount text-primary">
                                                        <fmt:formatNumber value="${payment.totalAmount}" type="number" maxFractionDigits="0"/> VNĐ
                                                    </div>
                                                    <div class="mt-2">
                                                        <a href="${pageContext.request.contextPath}/user/bills/view/${payment.invoiceId}" 
                                                           class="btn btn-outline-primary btn-sm">
                                                            <i class="bi bi-eye me-1"></i>Chi tiết
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-payments">
                                        <i class="bi bi-receipt text-muted" style="font-size: 4rem;"></i>
                                        <h5 class="text-muted mt-3">
                                            <c:choose>
                                                <c:when test="${filterYear != null}">
                                                    Không tìm thấy thanh toán nào trong năm ${filterYear}
                                                </c:when>
                                                <c:otherwise>
                                                    Bạn chưa có lịch sử thanh toán nào
                                                </c:otherwise>
                                            </c:choose>
                                        </h5>
                                        <p class="text-muted">
                                            <c:choose>
                                                <c:when test="${filterYear != null}">
                                                    Thử thay đổi năm hoặc xóa bộ lọc để xem tất cả thanh toán.
                                                </c:when>
                                                <c:otherwise>
                                                    Khi có hóa đơn được thanh toán, chúng sẽ hiển thị ở đây.
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                        <div class="mt-4">
                                            <c:choose>
                                                <c:when test="${filterYear != null}">
                                                    <a href="${pageContext.request.contextPath}/user/payments" class="btn btn-primary">
                                                        <i class="bi bi-arrow-clockwise me-2"></i>Xóa bộ lọc
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/user/bills" class="btn btn-primary">
                                                        <i class="bi bi-receipt me-2"></i>Xem hóa đơn của tôi
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Add some interactive feedback
            const paymentItems = document.querySelectorAll('.payment-item');
            paymentItems.forEach(item => {
                item.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-2px)';
                });
                
                item.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                });
            });
            
            // Auto-submit form when filters change
            const filterForm = document.querySelector('form');
            const yearFilter = document.getElementById('yearFilter');
            
            if (yearFilter) {
                yearFilter.addEventListener('change', function() {
                    filterForm.submit();
                });
            }
        });
    </script>
</body>
</html>
