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
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }
        
        .required {
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
                
                <!-- Form Content -->
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
                            <li class="breadcrumb-item active">${pageTitle}</li>
                        </ol>
                    </nav>
                    
                    <!-- Error Messages -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>
                            ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <!-- Room Form -->
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <c:choose>
                                    <c:when test="${action == 'add'}">
                                        <i class="bi bi-plus-circle me-2"></i>
                                        Thêm Phòng mới
                                    </c:when>
                                    <c:otherwise>
                                        <i class="bi bi-pencil me-2"></i>
                                        Chỉnh sửa Phòng
                                    </c:otherwise>
                                </c:choose>
                            </h5>
                        </div>
                        <div class="card-body">
                            <form method="POST" id="roomForm">
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="roomName" class="form-label">
                                            <i class="bi bi-door-closed me-1"></i>
                                            Tên Phòng <span class="required">*</span>
                                        </label>
                                        <input type="text" 
                                               class="form-control" 
                                               id="roomName" 
                                               name="roomName" 
                                               value="${room.roomName}"
                                               placeholder="Ví dụ: P101, A201" 
                                               required 
                                               maxlength="50">
                                        <div class="form-text">Tên phòng phải là duy nhất</div>
                                    </div>
                                    
                                    <div class="col-md-6 mb-3">
                                        <label for="price" class="form-label">
                                            <i class="bi bi-currency-dollar me-1"></i>
                                            Giá Phòng (VNĐ) <span class="required">*</span>
                                        </label>
                                        <input type="number" 
                                               class="form-control" 
                                               id="price" 
                                               name="price" 
                                               value="${room.price}"
                                               placeholder="Ví dụ: 2000000" 
                                               required 
                                               min="1">
                                        <div class="form-text">Nhập giá phòng (VNĐ)</div>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="status" class="form-label">
                                        <i class="bi bi-toggle-on me-1"></i>
                                        Trạng thái <span class="required">*</span>
                                    </label>
                                    <select class="form-select" id="status" name="status" required>
                                        <option value="AVAILABLE" 
                                                <c:if test="${room.status == 'AVAILABLE'}">selected</c:if>>
                                            Có sẵn
                                        </option>
                                        <option value="OCCUPIED" 
                                                <c:if test="${room.status == 'OCCUPIED'}">selected</c:if>>
                                            Đã thuê
                                        </option>
                                    </select>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="description" class="form-label">
                                        <i class="bi bi-card-text me-1"></i>
                                        Mô tả
                                    </label>
                                    <textarea class="form-control" 
                                              id="description" 
                                              name="description" 
                                              rows="4" 
                                              placeholder="Mô tả về phòng trọ (tùy chọn)"
                                              maxlength="1000">${room.description}</textarea>
                                    <div class="form-text">Tối đa 1000 ký tự</div>
                                </div>
                                
                                <div class="d-flex justify-content-between">
                                    <a href="${pageContext.request.contextPath}/admin/rooms" 
                                       class="btn btn-secondary">
                                        <i class="bi bi-arrow-left me-1"></i>
                                        Quay lại
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <c:choose>
                                            <c:when test="${action == 'add'}">
                                                <i class="bi bi-plus-circle me-1"></i>
                                                Thêm Phòng
                                            </c:when>
                                            <c:otherwise>
                                                <i class="bi bi-check-circle me-1"></i>
                                                Cập nhật
                                            </c:otherwise>
                                        </c:choose>
                                    </button>
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
        // Form validation
        document.getElementById('roomForm').addEventListener('submit', function(e) {
            const roomName = document.getElementById('roomName').value.trim();
            const price = document.getElementById('price').value;
            
            if (!roomName) {
                e.preventDefault();
                alert('Vui lòng nhập tên phòng');
                return false;
            }
            
            if (!price || price <= 0) {
                e.preventDefault();
                alert('Vui lòng nhập giá phòng hợp lệ');
                return false;
            }
        });
        
        // Format price input
        document.getElementById('price').addEventListener('input', function(e) {
            // Remove any non-digit characters except for the decimal point
            this.value = this.value.replace(/[^0-9]/g, '');
        });
    </script>
</body>
</html>
