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
        
        .form-control:focus,
        .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
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
        
        .tenant-card {
            border: 2px solid #dee2e6;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.2s;
            background: white;
        }
        
        .tenant-card:hover {
            border-color: #667eea;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.2);
        }
        
        .tenant-card.selected {
            border-color: #667eea;
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
        }
        
        .tenant-avatar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 1.2rem;
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
        
        .selection-grid {
            max-height: 400px;
            overflow-y: auto;
        }
        
        .required-field {
            color: #dc3545;
        }
        
        .selected-info {
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
            border: 2px solid #667eea;
            border-radius: 10px;
            padding: 15px;
        }
        
        .cost-preview {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            border-left: 4px solid #667eea;
        }
        
        .amount-input {
            font-size: 1.1rem;
            font-weight: 500;
        }
        
        .date-today {
            color: #28a745;
            font-weight: 500;
        }
        
        /* Cost Template Styles */
        .cost-templates-section {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin: 20px 0;
        }
        
        .cost-template-item {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 12px;
            margin: 5px;
            transition: all 0.3s ease;
            cursor: pointer;
            background: white;
            text-align: center;
            min-height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
        }
        
        .cost-template-item:hover {
            border-color: #667eea;
            box-shadow: 0 2px 8px rgba(102, 126, 234, 0.2);
            transform: translateY(-2px);
        }
        
        .cost-template-item.selected {
            border-color: #667eea;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .cost-template-item i {
            font-size: 1.2em;
            margin-bottom: 4px;
        }
        
        .cost-template-item span {
            font-size: 0.9em;
            font-weight: 500;
        }
        
        /* Selected Cost Display */
        #costDisplay .badge {
            font-size: 1em;
            padding: 8px 12px;
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/additional-costs">
                            <i class="bi bi-receipt-cutoff me-2"></i>
                            Chi phí phát sinh
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/bills">
                            <i class="bi bi-receipt me-2"></i>
                            Quản lý Hóa đơn
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
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Thông tin cá nhân</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile/change-password">Đổi mật khẩu</a></li>
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
                    <nav class="breadcrumb mb-4">
                        <a class="breadcrumb-item text-decoration-none" href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="bi bi-house me-1"></i>Dashboard
                        </a>
                        <a class="breadcrumb-item text-decoration-none" href="${pageContext.request.contextPath}/admin/additional-costs">
                            Chi phí phát sinh
                        </a>
                        <span class="breadcrumb-item active">
                            <c:choose>
                                <c:when test="${action == 'add'}">Thêm mới</c:when>
                                <c:otherwise>Chỉnh sửa</c:otherwise>
                            </c:choose>
                        </span>
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
                    
                    <!-- Form -->
                    <form method="POST" id="additionalCostForm">
                        <div class="row">
                            <div class="col-lg-8">
                                <!-- Tenant Selection Section -->
                                <div class="form-section">
                                    <h5 class="section-title">
                                        <i class="bi bi-person-check me-2"></i>
                                        Chọn Khách thuê <span class="required-field">*</span>
                                    </h5>
                                    
                                    <c:choose>
                                        <c:when test="${action == 'edit'}">
                                            <!-- For edit mode, show selected tenant info -->
                                            <div class="selected-info">
                                                <div class="row align-items-center">
                                                    <div class="col-auto">
                                                        <div class="tenant-avatar">
                                                            ${additionalCost.tenantName.substring(0, 1).toUpperCase()}
                                                        </div>
                                                    </div>
                                                    <div class="col">
                                                        <h6 class="mb-1">${additionalCost.tenantName}</h6>
                                                        <div class="text-muted">
                                                            <small>
                                                                <i class="bi bi-door-open me-1"></i>
                                                                Phòng: ${additionalCost.roomName}
                                                            </small>
                                                            <small class="ms-3">
                                                                <i class="bi bi-person-badge me-1"></i>
                                                                ID: ${additionalCost.tenantId}
                                                            </small>
                                                        </div>
                                                    </div>
                                                </div>
                                                <input type="hidden" name="tenantId" value="${additionalCost.tenantId}">
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <!-- For add mode, show tenant selection -->
                                            <div class="mb-3">
                                                <input type="text" 
                                                       class="form-control" 
                                                       id="tenantSearch" 
                                                       placeholder="Tìm kiếm khách thuê theo tên..."
                                                       onkeyup="filterTenants(this.value)">
                                            </div>
                                            
                                            <div class="selection-grid">
                                                <div class="row" id="tenantGrid">
                                                    <c:forEach var="tenant" items="${tenants}" varStatus="status">
                                                        <div class="col-md-6 col-xl-4 mb-3 tenant-item" data-name="${tenant.fullName}">
                                                            <div class="tenant-card h-100 p-3" onclick="selectTenant(${tenant.tenantId}, '${tenant.fullName}', '${tenant.roomName}')">
                                                                <div class="row align-items-center">
                                                                    <div class="col-auto">
                                                                        <div class="tenant-avatar">
                                                                            ${tenant.fullName.substring(0, 1).toUpperCase()}
                                                                        </div>
                                                                    </div>
                                                                    <div class="col">
                                                                        <h6 class="mb-1">${tenant.fullName}</h6>
                                                                        <div class="text-muted">
                                                                            <small>
                                                                                <i class="bi bi-door-open me-1"></i>
                                                                                ${tenant.roomName}
                                                                            </small>
                                                                            <br>
                                                                            <small>
                                                                                <i class="bi bi-person-badge me-1"></i>
                                                                                ID: ${tenant.tenantId}
                                                                            </small>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <input type="hidden" name="tenantId" id="selectedTenantId" required>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <!-- Cost Templates Section -->
                                <div class="cost-templates-section mb-4">
                                    <h6 class="mb-3">
                                        <i class="bi bi-lightbulb me-2"></i>
                                        Chọn chi phí phát sinh phổ biến:
                                    </h6>
                                    <p class="text-muted mb-3">Click chọn chi phí có sẵn hoặc nhập chi phí khác:</p>
                                    
                                    <div class="row">
                                        <!-- Chi phí sửa chữa -->
                                        <div class="col-md-3 col-sm-6 mb-2">
                                            <div class="cost-template-item" onclick="selectCostTemplate('repair_ac')">
                                                <i class="bi bi-snow me-2"></i>
                                                <span>Sửa điều hòa</span>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-3 col-sm-6 mb-2">
                                            <div class="cost-template-item" onclick="selectCostTemplate('repair_fan')">
                                                <i class="bi bi-fan me-2"></i>
                                                <span>Sửa quạt trần</span>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-3 col-sm-6 mb-2">
                                            <div class="cost-template-item" onclick="selectCostTemplate('repair_light')">
                                                <i class="bi bi-lightbulb me-2"></i>
                                                <span>Thay bóng đèn</span>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-3 col-sm-6 mb-2">
                                            <div class="cost-template-item" onclick="selectCostTemplate('repair_plumbing')">
                                                <i class="bi bi-droplet me-2"></i>
                                                <span>Sửa ống nước</span>
                                            </div>
                                        </div>
                                        
                                        <!-- Chi phí phạt -->
                                        <div class="col-md-3 col-sm-6 mb-2">
                                            <div class="cost-template-item" onclick="selectCostTemplate('fine_noise')">
                                                <i class="bi bi-volume-up me-2"></i>
                                                <span>Phạt ồn ào</span>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-3 col-sm-6 mb-2">
                                            <div class="cost-template-item" onclick="selectCostTemplate('fine_smoking')">
                                                <i class="bi bi-x-circle me-2"></i>
                                                <span>Phạt hút thuốc</span>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-3 col-sm-6 mb-2">
                                            <div class="cost-template-item" onclick="selectCostTemplate('fine_late')">
                                                <i class="bi bi-clock me-2"></i>
                                                <span>Phạt trả phòng muộn</span>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-3 col-sm-6 mb-2">
                                            <div class="cost-template-item" onclick="selectCostTemplate('fine_damage')">
                                                <i class="bi bi-exclamation-triangle me-2"></i>
                                                <span>Phạt làm hỏng đồ</span>
                                            </div>
                                        </div>
                                        
                                        <!-- Chi phí dịch vụ -->
                                        <div class="col-md-3 col-sm-6 mb-2">
                                            <div class="cost-template-item" onclick="selectCostTemplate('cleaning')">
                                                <i class="bi bi-brush me-2"></i>
                                                <span>Vệ sinh phòng</span>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-3 col-sm-6 mb-2">
                                            <div class="cost-template-item" onclick="selectCostTemplate('key_replacement')">
                                                <i class="bi bi-key me-2"></i>
                                                <span>Làm chìa khóa</span>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-3 col-sm-6 mb-2">
                                            <div class="cost-template-item" onclick="selectCostTemplate('pest_control')">
                                                <i class="bi bi-bug me-2"></i>
                                                <span>Diệt côn trùng</span>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-3 col-sm-6 mb-2">
                                            <div class="cost-template-item" onclick="selectCostTemplate('moving_fee')">
                                                <i class="bi bi-truck me-2"></i>
                                                <span>Phí chuyển đồ</span>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Chi phí tùy chọn -->
                                    <div class="mt-3">
                                        <label for="customCost" class="form-label">
                                            <i class="bi bi-plus-circle me-1"></i>
                                            Chi phí khác (tùy chọn)
                                        </label>
                                        <div class="input-group">
                                            <input type="text" 
                                                   class="form-control" 
                                                   id="customCost" 
                                                   placeholder="Nhập mô tả chi phí khác..." 
                                                   maxlength="255">
                                            <button type="button" 
                                                    class="btn btn-outline-primary" 
                                                    onclick="addCustomCost()">
                                                <i class="bi bi-plus"></i>
                                                Chọn
                                            </button>
                                        </div>
                                        <div class="form-text">Ví dụ: Sửa khóa cửa, Thay thảm, Phí gửi xe...</div>
                                    </div>
                                    
                                    <!-- Hiển thị chi phí đã chọn -->
                                    <div class="mt-3" id="selectedCost" style="display: none;">
                                        <h6 class="text-primary">Chi phí đã chọn:</h6>
                                        <div id="costDisplay" class="d-flex flex-wrap gap-2"></div>
                                    </div>
                                </div>
                                
                                <!-- Cost Information Section -->
                                <div class="form-section">
                                    <h5 class="section-title">
                                        <i class="bi bi-receipt-cutoff me-2"></i>
                                        Thông tin Chi phí
                                    </h5>
                                    
                                    <div class="row">
                                        <!-- Hidden input for description -->
                                        <input type="hidden" name="description" id="descriptionHidden" value="">
                                        
                                        <div class="col-md-6 mb-3">
                                            <label for="amount" class="form-label">
                                                Số tiền <span class="required-field">*</span>
                                            </label>
                                            <div class="input-group">
                                                <input type="number" 
                                                       class="form-control amount-input" 
                                                       id="amount" 
                                                       name="amount" 
                                                       placeholder="0"
                                                       step="1000"
                                                       min="1000"
                                                       max="99999999"
                                                       value="${additionalCost.amount}"
                                                       required
                                                       onchange="updateAmountDisplay()">
                                                <span class="input-group-text">₫</span>
                                            </div>
                                            <div class="form-text">
                                                Số tiền từ 1,000₫ đến 99,999,999₫
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-6 mb-3">
                                            <label for="dateString" class="form-label">
                                                Ngày phát sinh <span class="required-field">*</span>
                                            </label>
                                            <input type="date" 
                                                   class="form-control" 
                                                   id="dateString" 
                                                   name="dateString" 
                                                   value="${action == 'edit' ? formattedDate : ''}"
                                                   max="<fmt:formatDate value='<%=new java.util.Date()%>' pattern='yyyy-MM-dd'/>"
                                                   required>
                                            <div class="form-text">
                                                <span class="date-today">Hôm nay: <fmt:formatDate value="<%=new java.util.Date()%>" pattern="dd/MM/yyyy"/></span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Preview/Summary Section -->
                            <div class="col-lg-4">
                                <div class="form-section sticky-top" style="top: 20px;">
                                    <h5 class="section-title">
                                        <i class="bi bi-eye me-2"></i>
                                        Xem trước
                                    </h5>
                                    
                                    <div class="cost-preview">
                                        <div class="mb-3">
                                            <strong>Khách thuê:</strong>
                                            <div id="previewTenant" class="text-muted">
                                                <c:choose>
                                                    <c:when test="${action == 'edit'}">
                                                        ${additionalCost.tenantName} (${additionalCost.roomName})
                                                    </c:when>
                                                    <c:otherwise>
                                                        Chưa chọn
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <strong>Mô tả:</strong>
                                            <div id="previewDescription" class="text-muted">
                                                <c:choose>
                                                    <c:when test="${not empty additionalCost.description}">
                                                        ${additionalCost.description}
                                                    </c:when>
                                                    <c:otherwise>
                                                        Chưa chọn
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <strong>Số tiền:</strong>
                                            <div id="previewAmount" class="text-danger h5">
                                                <c:choose>
                                                    <c:when test="${not empty additionalCost.amount}">
                                                        <fmt:formatNumber value="${additionalCost.amount}" 
                                                                        type="currency" 
                                                                        currencySymbol="₫" 
                                                                        groupingUsed="true"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        0₫
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <strong>Ngày phát sinh:</strong>
                                            <div id="previewDate" class="text-muted">
                                                <c:choose>
                                                    <c:when test="${not empty formattedDate}">
                                                        <fmt:parseDate value="${formattedDate}" pattern="yyyy-MM-dd" var="parsedDate" />
                                                        <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        Chưa chọn
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Action Buttons -->
                                    <div class="d-grid gap-2 mt-4">
                                        <button type="submit" class="btn btn-primary btn-lg">
                                            <i class="bi bi-check-circle me-2"></i>
                                            <c:choose>
                                                <c:when test="${action == 'add'}">Thêm chi phí</c:when>
                                                <c:otherwise>Cập nhật chi phí</c:otherwise>
                                            </c:choose>
                                        </button>
                                        <a href="${pageContext.request.contextPath}/admin/additional-costs" 
                                           class="btn btn-secondary">
                                            <i class="bi bi-arrow-left me-2"></i>
                                            Quay lại
                                        </a>
                                    </div>
                                    
                                    <div class="mt-4">
                                        <div class="alert alert-info">
                                            <i class="bi bi-info-circle me-2"></i>
                                            <strong>Lưu ý:</strong>
                                            <ul class="mb-0 mt-2">
                                                <li>Chi phí phát sinh sẽ được tính vào hóa đơn tháng tương ứng</li>
                                                <li>Chỉ có thể thêm chi phí cho ngày hiện tại hoặc quá khứ</li>
                                                <li>Mô tả chi phí nên rõ ràng để dễ theo dõi</li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // ==================== BIẾN TOÀN CỤC ====================
        
        let selectedCostDescription = '';
        
        // Cost templates data
        const costTemplates = {
            'repair_ac': 'Sửa chữa điều hòa',
            'repair_fan': 'Sửa chữa quạt trần',
            'repair_light': 'Thay bóng đèn',
            'repair_plumbing': 'Sửa chữa ống nước',
            'fine_noise': 'Phạt gây ồn ào',
            'fine_smoking': 'Phạt hút thuốc trong phòng',
            'fine_late': 'Phạt trả phòng muộn',
            'fine_damage': 'Phạt làm hỏng tài sản',
            'cleaning': 'Dịch vụ vệ sinh phòng',
            'key_replacement': 'Làm chìa khóa mới',
            'pest_control': 'Dịch vụ diệt côn trùng',
            'moving_fee': 'Phí chuyển đồ đạc'
        };
        
        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            // Set today's date as default for new costs
            <c:if test="${action == 'add'}">
                const today = new Date().toISOString().split('T')[0];
                document.getElementById('dateString').value = today;
            </c:if>
            
            // For edit mode, set the existing description
            <c:if test="${action == 'edit' && not empty additionalCost.description}">
                selectedCostDescription = '${additionalCost.description}';
                document.getElementById('descriptionHidden').value = selectedCostDescription;
                updateSelectedCostDisplay();
                updatePreviewDescription();
            </c:if>
            
            // Add event listeners
            document.getElementById('amount').addEventListener('input', updateAmountDisplay);
            document.getElementById('dateString').addEventListener('change', updatePreviewDate);
            
            // Handle Enter key in custom cost input
            document.getElementById('customCost').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    addCustomCost();
                }
            });
        });
        
        // ==================== COST TEMPLATE FUNCTIONS ====================
        
        function selectCostTemplate(templateKey) {
            const template = costTemplates[templateKey];
            if (!template) return;
            
            // Clear previous selections
            document.querySelectorAll('.cost-template-item').forEach(item => {
                item.classList.remove('selected');
            });
            
            // Mark as selected
            event.target.closest('.cost-template-item').classList.add('selected');
            
            // Set cost description
            selectedCostDescription = template;
            
            // Update display
            updateSelectedCostDisplay();
            updatePreviewDescription();
        }
        
        function addCustomCost() {
            const input = document.getElementById('customCost');
            const value = input.value.trim();
            
            if (value) {
                // Clear template selections
                document.querySelectorAll('.cost-template-item').forEach(item => {
                    item.classList.remove('selected');
                });
                
                selectedCostDescription = value;
                input.value = '';
                updateSelectedCostDisplay();
                updatePreviewDescription();
            }
        }
        
        function updateSelectedCostDisplay() {
            const container = document.getElementById('selectedCost');
            const display = document.getElementById('costDisplay');
            
            if (selectedCostDescription) {
                container.style.display = 'block';
                display.innerHTML = 
                    '<span class="badge bg-primary" style="font-size: 1em; padding: 8px 12px;">' +
                        '<i class="bi bi-check-circle me-1"></i>' +
                        selectedCostDescription +
                        '<button type="button" class="btn-close btn-close-white ms-2" ' +
                                'onclick="clearSelectedCost()" ' +
                                'style="font-size: 0.8em;"></button>' +
                    '</span>';
                
                // Update hidden input
                document.getElementById('descriptionHidden').value = selectedCostDescription;
            } else {
                container.style.display = 'none';
            }
        }
        
        function clearSelectedCost() {
            selectedCostDescription = '';
            document.querySelectorAll('.cost-template-item').forEach(item => {
                item.classList.remove('selected');
            });
            updateSelectedCostDisplay();
            updatePreviewDescription();
        }
        
        // ==================== TENANT SELECTION FUNCTIONS ====================
        function selectTenant(tenantId, tenantName, roomName) {
            // Clear previous selections
            document.querySelectorAll('.tenant-card').forEach(card => {
                card.classList.remove('selected');
            });
            
            // Select current tenant
            event.currentTarget.classList.add('selected');
            document.getElementById('selectedTenantId').value = tenantId;
            
            // Update preview
            document.getElementById('previewTenant').textContent = tenantName + ' (' + roomName + ')';
        }
        
        function filterTenants(searchTerm) {
            const items = document.querySelectorAll('.tenant-item');
            const normalizedSearch = searchTerm.toLowerCase().trim();
            
            items.forEach(item => {
                const tenantName = item.dataset.name.toLowerCase();
                if (tenantName.includes(normalizedSearch)) {
                    item.style.display = '';
                } else {
                    item.style.display = 'none';
                }
            });
        }
        
        // ==================== PREVIEW UPDATE FUNCTIONS ====================
        
        function updatePreviewDescription() {
            const description = selectedCostDescription || 'Chưa chọn';
            document.getElementById('previewDescription').textContent = description;
        }
        
        function updateAmountDisplay() {
            const amount = parseFloat(document.getElementById('amount').value) || 0;
            const formatted = new Intl.NumberFormat('vi-VN', {
                style: 'currency',
                currency: 'VND',
                currencyDisplay: 'symbol',
                minimumFractionDigits: 0
            }).format(amount).replace('₫', '₫');
            
            document.getElementById('previewAmount').textContent = formatted;
        }
        
        function updatePreviewDate() {
            const dateValue = document.getElementById('dateString').value;
            if (dateValue) {
                const date = new Date(dateValue + 'T00:00:00');
                const formatted = date.toLocaleDateString('vi-VN');
                document.getElementById('previewDate').textContent = formatted;
            } else {
                document.getElementById('previewDate').textContent = 'Chưa chọn';
            }
        }
        
        // ==================== FORM VALIDATION ====================
        
        document.getElementById('additionalCostForm').addEventListener('submit', function(e) {
            <c:if test="${action == 'add'}">
                const tenantId = document.getElementById('selectedTenantId').value;
                if (!tenantId) {
                    e.preventDefault();
                    alert('Vui lòng chọn khách thuê!');
                    return false;
                }
            </c:if>
            
            // Validate cost description
            if (!selectedCostDescription.trim()) {
                e.preventDefault();
                alert('Vui lòng chọn hoặc nhập mô tả chi phí!');
                return false;
            }
            
            const amount = parseFloat(document.getElementById('amount').value);
            if (amount < 1000 || amount > 99999999) {
                e.preventDefault();
                alert('Số tiền phải từ 1,000₫ đến 99,999,999₫!');
                return false;
            }
            
            // Update hidden input before submit
            document.getElementById('descriptionHidden').value = selectedCostDescription;
        });
    </script>
</body>
</html>
