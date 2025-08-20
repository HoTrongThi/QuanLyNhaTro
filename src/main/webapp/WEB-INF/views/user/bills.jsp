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
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        
        .invoice-card {
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .invoice-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 25px rgba(0,0,0,0.15);
        }
        
        .badge-paid {
            background: linear-gradient(135deg, #28a745, #20c997);
        }
        
        .badge-unpaid {
            background: linear-gradient(135deg, #dc3545, #fd7e14);
        }
        
        .amount-large {
            font-size: 1.5rem;
            font-weight: bold;
        }
        
        .btn-custom {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            border-radius: 10px;
            color: white;
        }
        
        .btn-custom:hover {
            background: linear-gradient(135deg, #20c997 0%, #28a745 100%);
            color: white;
        }
        
        .welcome-card {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }
        
        .invoice-summary {
            background: linear-gradient(135deg, #e8f5e8, #f0fff4);
            border-radius: 10px;
            border-left: 4px solid #28a745;
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/user/bills">
                            <i class="bi bi-receipt me-2"></i>
                            Hóa đơn của tôi
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/user/payments">
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
                
                <!-- Bills Content -->
                <div class="p-4">
                
                <!-- Welcome Card -->
                <div class="card welcome-card mb-4">
                    <div class="card-body">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <h5 class="mb-2">
                                    <i class="bi bi-person-check me-2"></i>Chào mừng, ${user.fullName}!
                                </h5>
                                <p class="mb-0 opacity-75">
                                    Dưới đây là danh sách tất cả hóa đơn của bạn. Bạn có thể xem chi tiết từng hóa đơn 
                                    để biết thông tin về tiền phòng, dịch vụ và các chi phí phát sinh.
                                </p>
                            </div>
                            <div class="col-md-4 text-end">
                                <i class="bi bi-file-earmark-text fs-1 opacity-50"></i>
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
                
                <!-- Bills List -->
                <c:choose>
                    <c:when test="${not empty invoices}">
                        <div class="row">
                            <c:forEach var="invoice" items="${invoices}">
                                <div class="col-md-6 col-lg-4 mb-4">
                                    <div class="card invoice-card h-100" onclick="window.location.href='${pageContext.request.contextPath}/user/bills/view/${invoice.invoiceId}'">
                                        <div class="card-header d-flex justify-content-between align-items-center">
                                            <h6 class="mb-0">
                                                <i class="bi bi-file-earmark-text me-2"></i>
                                                Hóa đơn #${invoice.invoiceId}
                                            </h6>
                                            <c:choose>
                                                <c:when test="${invoice.status == 'PAID'}">
                                                    <span class="badge badge-paid">
                                                        <i class="bi bi-check-circle me-1"></i>Đã thanh toán
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-unpaid">
                                                        <i class="bi bi-exclamation-circle me-1"></i>Chưa thanh toán
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        
                                        <div class="card-body">
                                            <div class="invoice-summary p-3 mb-3">
                                                <div class="row text-center">
                                                    <div class="col">
                                                        <strong class="text-primary">Kỳ thanh toán</strong><br>
                                                        <span class="fs-5">${invoice.formattedPeriod}</span>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="row mb-3">
                                                <div class="col-6">
                                                    <small class="text-muted d-block">Tiền phòng</small>
                                                    <strong><fmt:formatNumber value="${invoice.roomPrice}" type="number" maxFractionDigits="0"/> VNĐ</strong>
                                                </div>
                                                <div class="col-6">
                                                    <small class="text-muted d-block">Dịch vụ</small>
                                                    <strong class="text-info"><fmt:formatNumber value="${invoice.serviceTotal}" type="number" maxFractionDigits="0"/> VNĐ</strong>
                                                </div>
                                            </div>
                                            
                                            <div class="row mb-3">
                                                <div class="col-6">
                                                    <small class="text-muted d-block">Chi phí PS</small>
                                                    <strong class="text-warning"><fmt:formatNumber value="${invoice.additionalTotal}" type="number" maxFractionDigits="0"/> VNĐ</strong>
                                                </div>
                                                <div class="col-6">
                                                    <small class="text-muted d-block">Ngày tạo</small>
                                                    <strong><fmt:formatDate value="${invoice.createdAt}" pattern="dd/MM/yyyy"/></strong>
                                                </div>
                                            </div>
                                            
                                            <hr>
                                            
                                            <div class="d-flex justify-content-between align-items-center">
                                                <span class="text-muted">Tổng tiền:</span>
                                                <span class="amount-large text-success">
                                                    <fmt:formatNumber value="${invoice.totalAmount}" type="number" maxFractionDigits="0"/> VNĐ
                                                </span>
                                            </div>
                                        </div>
                                        
                                        <div class="card-footer bg-transparent">
                                            <div class="d-grid">
                                                <div class="btn btn-custom btn-sm">
                                                    <i class="bi bi-eye me-2"></i>Xem chi tiết
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        
                        <!-- Bank Account Information -->
                        <div class="card mt-4">
                            <div class="card-header">
                                <h6 class="mb-0">
                                    <i class="bi bi-credit-card me-2"></i>
                                    Thông tin thanh toán trực tuyến
                                </h6>
                            </div>
                            <div class="card-body">
                                <div class="alert alert-info mb-4">
                                    <div class="d-flex align-items-center">
                                        <i class="bi bi-info-circle fs-4 me-3"></i>
                                        <div>
                                            <h6 class="mb-1">Hướng dẫn thanh toán</h6>
                                            <p class="mb-0">Bạn có thể thanh toán hóa đơn bằng cách chuyển khoản vào tài khoản ngân hàng dưới đây. Vui lòng ghi rõ <strong>mã hóa đơn</strong> trong nội dung chuyển khoản.</p>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="row g-4">
                                    <!-- Main Bank Account -->
                                    <div class="col-md-6">
                                        <div class="card border-primary h-100">
                                            <div class="card-header bg-primary text-white">
                                                <h6 class="mb-0">
                                                    <i class="bi bi-bank me-2"></i>
                                                    Ngân hàng chính
                                                </h6>
                                            </div>
                                            <div class="card-body">
                                                <div class="bank-info">
                                                    <div class="info-row mb-3">
                                                        <div class="d-flex justify-content-between align-items-center">
                                                            <strong class="text-muted">Ngân hàng:</strong>
                                                            <span class="fw-bold">Vietcombank</span>
                                                        </div>
                                                    </div>
                                                    <div class="info-row mb-3">
                                                        <div class="d-flex justify-content-between align-items-center">
                                                            <strong class="text-muted">Tên tài khoản:</strong>
                                                            <span class="fw-bold">HO TRONG THI</span>
                                                        </div>
                                                    </div>
                                                    <div class="info-row mb-3">
                                                        <div class="d-flex justify-content-between align-items-center">
                                                            <strong class="text-muted">Số tài khoản:</strong>
                                                            <div class="d-flex align-items-center">
                                                                <span class="fw-bold me-2" id="account1">1234567890</span>
                                                                <button class="btn btn-outline-primary btn-sm" onclick="copyToClipboard('account1', this)" title="Sao chép số tài khoản">
                                                                    <i class="bi bi-copy"></i>
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="info-row">
                                                        <div class="d-flex justify-content-between align-items-center">
                                                            <strong class="text-muted">Chi nhánh:</strong>
                                                            <span class="fw-bold">TP. Quy Nhon</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Secondary Bank Account -->
                                    <div class="col-md-6">
                                        <div class="card border-success h-100">
                                            <div class="card-header bg-success text-white">
                                                <h6 class="mb-0">
                                                    <i class="bi bi-bank me-2"></i>
                                                    Ngân hàng phụ
                                                </h6>
                                            </div>
                                            <div class="card-body">
                                                <div class="bank-info">
                                                    <div class="info-row mb-3">
                                                        <div class="d-flex justify-content-between align-items-center">
                                                            <strong class="text-muted">Ngân hàng:</strong>
                                                            <span class="fw-bold">Techcombank</span>
                                                        </div>
                                                    </div>
                                                    <div class="info-row mb-3">
                                                        <div class="d-flex justify-content-between align-items-center">
                                                            <strong class="text-muted">Tên tài khoản:</strong>
                                                            <span class="fw-bold">HO TRONG THI</span>
                                                        </div>
                                                    </div>
                                                    <div class="info-row mb-3">
                                                        <div class="d-flex justify-content-between align-items-center">
                                                            <strong class="text-muted">Số tài khoản:</strong>
                                                            <div class="d-flex align-items-center">
                                                                <span class="fw-bold me-2" id="account2">0987654321</span>
                                                                <button class="btn btn-outline-success btn-sm" onclick="copyToClipboard('account2', this)" title="Sao chép số tài khoản">
                                                                    <i class="bi bi-copy"></i>
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="info-row">
                                                        <div class="d-flex justify-content-between align-items-center">
                                                            <strong class="text-muted">Chi nhánh:</strong>
                                                            <span class="fw-bold">TP. Quy Nhon</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Payment Instructions -->
                                <div class="row mt-4">
                                    <div class="col-12">
                                        <div class="card bg-light">
                                            <div class="card-body">
                                                <h6 class="text-primary mb-3">
                                                    <i class="bi bi-list-check me-2"></i>
                                                    Các bước thanh toán:
                                                </h6>
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <ol class="mb-0">
                                                            <li class="mb-2">
                                                                <strong>Bước 1:</strong> Chọn hóa đơn cần thanh toán và ghi nhớ <strong>mã hóa đơn</strong>
                                                            </li>
                                                            <li class="mb-2">
                                                                <strong>Bước 2:</strong> Chuyển khoản vào một trong các tài khoản trên
                                                            </li>
                                                            <li class="mb-0">
                                                                <strong>Bước 3:</strong> Ghi <strong>"Thanh toan hoa don #[Mã hóa đơn]"</strong> vào nội dung
                                                            </li>
                                                        </ol>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="bg-white p-3 rounded">
                                                            <h6 class="text-success mb-2">
                                                                <i class="bi bi-chat-text me-2"></i>Ví dụ nội dung:
                                                            </h6>
                                                            <div class="border rounded p-2 bg-light">
                                                                <code class="text-dark">Thanh toan hoa don #123</code>
                                                            </div>
                                                            <small class="text-muted mt-2 d-block">
                                                                <i class="bi bi-info-circle me-1"></i>
                                                                Thay "123" bằng mã hóa đơn thực tế
                                                            </small>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- No Bills -->
                        <div class="card">
                            <div class="card-body text-center py-5">
                                <i class="bi bi-file-earmark-text fs-1 text-muted mb-4"></i>
                                <h4 class="text-muted mb-3">Chưa có hóa đơn nào</h4>
                                <p class="text-muted mb-4">
                                    Hiện tại bạn chưa có hóa đơn nào được tạo.<br>
                                    Hóa đơn sẽ được quản trị viên tạo định kỳ hàng tháng.
                                </p>
                                <div class="d-flex justify-content-center">
                                    <div class="text-center">
                                        <i class="bi bi-info-circle text-primary me-2"></i>
                                        <small class="text-muted">
                                            Liên hệ quản trị viên nếu bạn có thắc mắc về hóa đơn
                                        </small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Function to copy account number to clipboard
        function copyToClipboard(elementId, button) {
            var accountNumber = document.getElementById(elementId).textContent;
            
            // Create temporary textarea to copy text
            var tempTextarea = document.createElement('textarea');
            tempTextarea.value = accountNumber;
            document.body.appendChild(tempTextarea);
            tempTextarea.select();
            
            try {
                document.execCommand('copy');
                
                // Change button icon and show success feedback
                var originalIcon = button.innerHTML;
                button.innerHTML = '<i class="bi bi-check"></i>';
                button.classList.add('btn-success');
                button.classList.remove('btn-outline-primary', 'btn-outline-success');
                
                // Create tooltip or alert
                var tooltip = document.createElement('div');
                tooltip.className = 'position-absolute bg-success text-white px-2 py-1 rounded small';
                tooltip.style.cssText = 'top: -30px; left: 50%; transform: translateX(-50%); z-index: 1000;';
                tooltip.textContent = 'Đã sao chép!';
                button.parentElement.style.position = 'relative';
                button.parentElement.appendChild(tooltip);
                
                // Reset button after 2 seconds
                setTimeout(function() {
                    button.innerHTML = originalIcon;
                    button.classList.remove('btn-success');
                    if (elementId === 'account1') {
                        button.classList.add('btn-outline-primary');
                    } else {
                        button.classList.add('btn-outline-success');
                    }
                    tooltip.remove();
                }, 2000);
                
            } catch (err) {
                console.error('Không thể sao chép: ', err);
                alert('Không thể sao chép tự động. Vui lòng sao chép thủ công: ' + accountNumber);
            }
            
            document.body.removeChild(tempTextarea);
        }
    </script>
</body>
</html>
