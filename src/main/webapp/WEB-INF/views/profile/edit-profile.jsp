<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa thông tin cá nhân - Quản lý Phòng trọ</title>
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
        
        .form-control:focus,
        .form-select:focus {
            border-color: #28a745;
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
        }
        
        .form-floating > label {
            color: #6c757d;
        }
        
        .form-floating > .form-control:focus ~ label,
        .form-floating > .form-control:not(:placeholder-shown) ~ label {
            color: #28a745;
        }
        
        .form-section {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .section-title {
            color: #28a745;
            font-weight: 600;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #dee2e6;
        }
        
        .current-info {
            background: rgba(40, 167, 69, 0.1);
            border: 1px solid #28a745;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
        }
        
        .required-field {
            color: #dc3545;
        }
        
        .character-count {
            font-size: 0.875rem;
            color: #6c757d;
        }
        
        .character-count.warning {
            color: #fd7e14;
        }
        
        .character-count.danger {
            color: #dc3545;
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/user/profile">
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
                        <h5 class="navbar-brand mb-0">Chỉnh sửa thông tin cá nhân</h5>
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

                <!-- Edit Profile Content -->
                <div class="container py-4">
                    <!-- Breadcrumb -->
                    <nav aria-label="breadcrumb" class="mb-4">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/user/profile">
                                    <i class="bi bi-person"></i> Thông tin cá nhân
                                </a>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page">Chỉnh sửa thông tin</li>
                        </ol>
                    </nav>
                    
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
                    
                    <!-- Edit Profile Form -->
                    <div class="card">
                        <div class="card-header text-center">
                            <h4 class="mb-0">
                                <i class="bi bi-pencil-square me-2"></i>
                                Chỉnh sửa thông tin cá nhân
                            </h4>
                            <p class="mb-0 mt-2 opacity-75">Cập nhật thông tin cá nhân của bạn</p>
                        </div>
                        
                        <div class="card-body p-4">
                            <form method="POST" action="${pageContext.request.contextPath}/user/profile/edit" novalidate>
                                <!-- Basic Information Section -->
                                <div class="form-section">
                                    <h6 class="section-title">
                                        <i class="bi bi-person-card me-2"></i>
                                        Thông tin cơ bản
                                    </h6>
                                    
                                    <div class="row">
                                        <div class="col-12 mb-3">
                                            <div class="form-floating">
                                                <input type="text" 
                                                       class="form-control ${not empty fullNameError ? 'is-invalid' : ''}" 
                                                       id="fullName" 
                                                       name="fullName" 
                                                       placeholder="Họ và tên"
                                                       value="${not empty fullName ? fullName : user.fullName}"
                                                       maxlength="100"
                                                       required>
                                                <label for="fullName">
                                                    Họ và tên <span class="required-field">*</span>
                                                </label>
                                                <c:if test="${not empty fullNameError}">
                                                    <div class="invalid-feedback">
                                                        <i class="bi bi-exclamation-circle me-1"></i>
                                                        ${fullNameError}
                                                    </div>
                                                </c:if>
                                                <div class="character-count mt-1">
                                                    <span id="fullNameCount">0</span>/100 ký tự
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="row">
                                        <div class="col-12 mb-3">
                                            <div class="form-floating">
                                                <input type="email" 
                                                       class="form-control ${not empty emailError ? 'is-invalid' : ''}" 
                                                       id="email" 
                                                       name="email" 
                                                       placeholder="Email"
                                                       value="${not empty email ? email : user.email}"
                                                       required>
                                                <label for="email">
                                                    Email <span class="required-field">*</span>
                                                </label>
                                                <c:if test="${not empty emailError}">
                                                    <div class="invalid-feedback">
                                                        <i class="bi bi-exclamation-circle me-1"></i>
                                                        ${emailError}
                                                    </div>
                                                </c:if>
                                            </div>
                                            <div class="current-info">
                                                <small class="text-muted">
                                                    <i class="bi bi-info-circle me-1"></i>
                                                    Email hiện tại: <strong>${user.email}</strong>
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Contact Information Section -->
                                <div class="form-section">
                                    <h6 class="section-title">
                                        <i class="bi bi-telephone me-2"></i>
                                        Thông tin liên hệ
                                    </h6>
                                    
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <div class="form-floating">
                                                <input type="tel" 
                                                       class="form-control ${not empty phoneError ? 'is-invalid' : ''}" 
                                                       id="phone" 
                                                       name="phone" 
                                                       placeholder="Số điện thoại"
                                                       value="${not empty phone ? phone : user.phone}"
                                                       pattern="[0-9]{10,11}"
                                                       maxlength="11">
                                                <label for="phone">Số điện thoại</label>
                                                <c:if test="${not empty phoneError}">
                                                    <div class="invalid-feedback">
                                                        <i class="bi bi-exclamation-circle me-1"></i>
                                                        ${phoneError}
                                                    </div>
                                                </c:if>
                                            </div>
                                            <small class="form-text text-muted">
                                                <i class="bi bi-info-circle me-1"></i>
                                                Định dạng: 10-11 chữ số (VD: 0901234567)
                                            </small>
                                        </div>
                                        
                                        <div class="col-md-6 mb-3">
                                            <div class="current-info">
                                                <h6 class="mb-2">Số điện thoại hiện tại:</h6>
                                                <c:choose>
                                                    <c:when test="${not empty user.phone}">
                                                        <span class="fw-bold">${user.phone}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Chưa cập nhật</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="row">
                                        <div class="col-12 mb-3">
                                            <div class="form-floating">
                                                <textarea class="form-control ${not empty addressError ? 'is-invalid' : ''}" 
                                                          id="address" 
                                                          name="address" 
                                                          placeholder="Địa chỉ"
                                                          style="min-height: 100px;"
                                                          maxlength="200">${not empty address ? address : user.address}</textarea>
                                                <label for="address">Địa chỉ</label>
                                                <c:if test="${not empty addressError}">
                                                    <div class="invalid-feedback">
                                                        <i class="bi bi-exclamation-circle me-1"></i>
                                                        ${addressError}
                                                    </div>
                                                </c:if>
                                                <div class="character-count mt-1">
                                                    <span id="addressCount">0</span>/200 ký tự
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="current-info">
                                        <h6 class="mb-2">Địa chỉ hiện tại:</h6>
                                        <c:choose>
                                            <c:when test="${not empty user.address}">
                                                <span>${user.address}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Chưa cập nhật</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                
                                <!-- Action Buttons -->
                                <div class="d-flex gap-3 justify-content-center">
                                    <button type="submit" class="btn btn-success btn-lg">
                                        <i class="bi bi-check-circle me-2"></i>
                                        Lưu thay đổi
                                    </button>
                                    <a href="${pageContext.request.contextPath}/user/profile" class="btn btn-outline-secondary btn-lg">
                                        <i class="bi bi-arrow-left me-2"></i>
                                        Quay lại
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Character count for full name
            const fullNameInput = document.getElementById('fullName');
            const fullNameCount = document.getElementById('fullNameCount');
            
            function updateFullNameCount() {
                const count = fullNameInput.value.length;
                fullNameCount.textContent = count;
                
                const countElement = fullNameCount.parentElement;
                countElement.className = 'character-count mt-1';
                
                if (count > 80) {
                    countElement.classList.add('warning');
                }
                if (count > 95) {
                    countElement.classList.add('danger');
                }
            }
            
            fullNameInput.addEventListener('input', updateFullNameCount);
            updateFullNameCount(); // Initial count
            
            // Character count for address
            const addressInput = document.getElementById('address');
            const addressCount = document.getElementById('addressCount');
            
            function updateAddressCount() {
                const count = addressInput.value.length;
                addressCount.textContent = count;
                
                const countElement = addressCount.parentElement;
                countElement.className = 'character-count mt-1';
                
                if (count > 160) {
                    countElement.classList.add('warning');
                }
                if (count > 190) {
                    countElement.classList.add('danger');
                }
            }
            
            addressInput.addEventListener('input', updateAddressCount);
            updateAddressCount(); // Initial count
            
            // Phone number formatting
            const phoneInput = document.getElementById('phone');
            phoneInput.addEventListener('input', function() {
                // Remove all non-digits
                this.value = this.value.replace(/\D/g, '');
                
                // Limit to 11 digits
                if (this.value.length > 11) {
                    this.value = this.value.slice(0, 11);
                }
            });
            
            // Form validation
            const form = document.querySelector('form');
            form.addEventListener('submit', function(e) {
                let isValid = true;
                
                // Validate full name
                if (fullNameInput.value.trim().length < 2) {
                    showFieldError(fullNameInput, 'Họ và tên phải có ít nhất 2 ký tự');
                    isValid = false;
                } else {
                    clearFieldError(fullNameInput);
                }
                
                // Validate email
                const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailPattern.test(document.getElementById('email').value)) {
                    showFieldError(document.getElementById('email'), 'Vui lòng nhập email hợp lệ');
                    isValid = false;
                } else {
                    clearFieldError(document.getElementById('email'));
                }
                
                // Validate phone (if provided)
                const phone = phoneInput.value.trim();
                if (phone && !/^[0-9]{10,11}$/.test(phone)) {
                    showFieldError(phoneInput, 'Số điện thoại phải có 10-11 chữ số');
                    isValid = false;
                } else {
                    clearFieldError(phoneInput);
                }
                
                if (!isValid) {
                    e.preventDefault();
                }
            });
            
            function showFieldError(field, message) {
                field.classList.add('is-invalid');
                
                let feedback = field.parentElement.querySelector('.invalid-feedback');
                if (!feedback) {
                    feedback = document.createElement('div');
                    feedback.className = 'invalid-feedback';
                    field.parentElement.appendChild(feedback);
                }
                
                feedback.innerHTML = `<i class="bi bi-exclamation-circle me-1"></i>${message}`;
            }
            
            function clearFieldError(field) {
                field.classList.remove('is-invalid');
                
                const feedback = field.parentElement.querySelector('.invalid-feedback:not([data-server])');
                if (feedback) {
                    feedback.remove();
                }
            }
            
            // Clear client-side validation on input
            document.querySelectorAll('input, textarea').forEach(field => {
                field.addEventListener('input', function() {
                    if (!this.getAttribute('data-server-error')) {
                        clearFieldError(this);
                    }
                });
            });
        });
    </script>
</body>
</html>
