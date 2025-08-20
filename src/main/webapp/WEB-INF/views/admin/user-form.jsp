<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
        
        .form-section {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 25px;
        }
        
        .section-title {
            color: #667eea;
            font-weight: 600;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f8f9fa;
        }
        
        .form-control:focus,
        .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .required-field {
            color: #dc3545;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }
        
        .password-toggle {
            cursor: pointer;
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
                
                <!-- Add User Content -->
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
                            <li class="breadcrumb-item active" aria-current="page">Thêm người dùng mới</li>
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
                    
                    <form method="POST" action="${pageContext.request.contextPath}/admin/users/add">
                        <!-- Basic Information Section -->
                        <div class="form-section">
                            <h5 class="section-title">
                                <i class="bi bi-person-plus me-2"></i>
                                Thông tin đăng nhập
                            </h5>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <label for="username" class="form-label">
                                        Tên đăng nhập <span class="required-field">*</span>
                                    </label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="username" 
                                           name="username" 
                                           value="${newUser.username}"
                                           required>
                                    <div class="form-text">Tên đăng nhập phải duy nhất trong hệ thống</div>
                                </div>
                                <div class="col-md-6">
                                    <label for="password" class="form-label">
                                        Mật khẩu <span class="required-field">*</span>
                                    </label>
                                    <div class="input-group">
                                        <input type="password" 
                                               class="form-control" 
                                               id="password" 
                                               name="password" 
                                               required>
                                        <button class="btn btn-outline-secondary password-toggle" 
                                                type="button" 
                                                onclick="togglePassword()">
                                            <i class="bi bi-eye" id="passwordIcon"></i>
                                        </button>
                                    </div>
                                    <div class="form-text">Mật khẩu nên có ít nhất 6 ký tự</div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Personal Information Section -->
                        <div class="form-section">
                            <h5 class="section-title">
                                <i class="bi bi-person-vcard me-2"></i>
                                Thông tin cá nhân
                            </h5>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <label for="fullName" class="form-label">
                                        Họ tên đầy đủ <span class="required-field">*</span>
                                    </label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="fullName" 
                                           name="fullName" 
                                           value="${newUser.fullName}"
                                           required>
                                </div>
                                <div class="col-md-6">
                                    <label for="email" class="form-label">
                                        Email <span class="required-field">*</span>
                                    </label>
                                    <input type="email" 
                                           class="form-control" 
                                           id="email" 
                                           name="email" 
                                           value="${newUser.email}"
                                           required>
                                    <div class="form-text">Email phải duy nhất trong hệ thống</div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <label for="phone" class="form-label">Số điện thoại</label>
                                    <input type="tel" 
                                           class="form-control" 
                                           id="phone" 
                                           name="phone" 
                                           value="${newUser.phone}">
                                    <div class="form-text">Định dạng: 0xxxxxxxxx</div>
                                </div>
                                <div class="col-md-6">
                                    <label for="role" class="form-label">
                                        Vai trò <span class="required-field">*</span>
                                    </label>
                                    <select class="form-select" id="role" name="role" required>
                                        <option value="">Chọn vai trò...</option>
                                        <option value="USER" ${newUser.role == 'USER' ? 'selected' : ''}>Người dùng</option>
                                        <option value="ADMIN" ${newUser.role == 'ADMIN' ? 'selected' : ''}>Quản trị viên</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-12">
                                    <label for="address" class="form-label">Địa chỉ</label>
                                    <textarea class="form-control" 
                                              id="address" 
                                              name="address" 
                                              rows="3">${newUser.address}</textarea>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Action Buttons -->
                        <div class="form-section">
                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-success">
                                    <i class="bi bi-person-plus me-2"></i>
                                    Thêm người dùng
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-left me-2"></i>
                                    Quay lại
                                </a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function togglePassword() {
            const passwordField = document.getElementById('password');
            const passwordIcon = document.getElementById('passwordIcon');
            
            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                passwordIcon.className = 'bi bi-eye-slash';
            } else {
                passwordField.type = 'password';
                passwordIcon.className = 'bi bi-eye';
            }
        }
        
        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            
            if (password.length < 6) {
                e.preventDefault();
                alert('Mật khẩu phải có ít nhất 6 ký tự');
                return false;
            }
            
            const email = document.getElementById('email').value;
            const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailPattern.test(email)) {
                e.preventDefault();
                alert('Định dạng email không hợp lệ');
                return false;
            }
            
            const phone = document.getElementById('phone').value;
            if (phone && !/^0\d{9,10}$/.test(phone)) {
                e.preventDefault();
                alert('Số điện thoại không hợp lệ. Định dạng: 0xxxxxxxxx');
                return false;
            }
        });
    </script>
</body>
</html>
