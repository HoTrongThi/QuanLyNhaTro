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
        
        .unit-suggestions {
            display: none;
            position: absolute;
            z-index: 1000;
            background: white;
            border: 1px solid #ccc;
            border-top: none;
            border-radius: 0 0 5px 5px;
            max-height: 200px;
            overflow-y: auto;
        }
        
        .unit-suggestion {
            padding: 8px 12px;
            cursor: pointer;
            border-bottom: 1px solid #eee;
        }
        
        .unit-suggestion:hover {
            background: #f8f9fa;
        }
        
        /* Service Template Styles */
        .service-templates-section {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin: 20px 0;
        }
        
        .service-template-item {
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
        
        .service-template-item:hover {
            border-color: #667eea;
            box-shadow: 0 2px 8px rgba(102, 126, 234, 0.2);
            transform: translateY(-2px);
        }
        
        .service-template-item.selected {
            border-color: #667eea;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .service-template-item i {
            font-size: 1.2em;
            margin-bottom: 4px;
        }
        
        .service-template-item span {
            font-size: 0.9em;
            font-weight: 500;
        }
        
        /* Service Type Styles */
        .service-type-section {
            background: #fff;
            border: 1px solid #dee2e6;
            border-radius: 10px;
            padding: 20px;
        }
        
        .service-type-option {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 15px;
            margin: 5px 0;
            transition: all 0.3s ease;
            background: white;
        }
        
        .service-type-option:hover {
            border-color: #667eea;
            box-shadow: 0 2px 8px rgba(102, 126, 234, 0.1);
        }
        
        .service-type-option input[type="radio"]:checked + label {
            color: #667eea;
            font-weight: 600;
        }
        
        .service-type-option input[type="radio"]:checked {
            border-color: #667eea;
        }
        
        .service-type-option label {
            cursor: pointer;
            margin-bottom: 0;
            width: 100%;
        }
        
        /* Service Config Styles */
        #serviceConfigSection {
            background: #fff;
            border: 1px solid #dee2e6;
            border-radius: 10px;
            padding: 20px;
            margin: 20px 0;
            min-height: 100px;
        }
        
        .config-section {
            display: none;
        }
        
        .config-section.active {
            display: block;
        }
        
        .tier-row {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin: 10px 0;
            border: 1px solid #dee2e6;
        }
        
        .tier-row .form-control {
            margin-bottom: 10px;
        }
        
        .add-tier-btn {
            border: 2px dashed #667eea;
            background: transparent;
            color: #667eea;
            padding: 10px;
            border-radius: 8px;
            width: 100%;
            margin: 10px 0;
        }
        
        .add-tier-btn:hover {
            background: #667eea;
            color: white;
        }
        
        /* Selected Service Display */
        #serviceDisplay .badge {
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/services">
                            <i class="bi bi-tools me-2"></i>
                            Quản lý Dịch vụ
                        </a>
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
                                <a href="${pageContext.request.contextPath}/admin/services">Quản lý Dịch vụ</a>
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
                    
                    <!-- Service Form -->
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <c:choose>
                                    <c:when test="${action == 'add'}">
                                        <i class="bi bi-plus-circle me-2"></i>
                                        Thêm Dịch vụ mới
                                    </c:when>
                                    <c:otherwise>
                                        <i class="bi bi-pencil me-2"></i>
                                        Chỉnh sửa Dịch vụ
                                    </c:otherwise>
                                </c:choose>
                            </h5>
                        </div>
                        <div class="card-body">
                            <form method="POST" id="serviceForm">
                                <!-- Tầng 1: Gợi ý Dịch vụ (giống Tiện nghi) -->
                                <div class="service-templates-section mb-4">
                                    <h6 class="mb-3">
                                        <i class="bi bi-lightbulb me-2"></i>
                                        Chọn dịch vụ phổ biến:
                                    </h6>
                                    <p class="text-muted mb-3">Click chọn dịch vụ có sẵn hoặc nhập dịch vụ khác:</p>
                                    
                                    <div class="row">
                                        <!-- Dịch vụ cơ bản -->
                                        <div class="col-md-3 col-sm-6 mb-2">
                                            <div class="service-template-item" onclick="selectServiceTemplate('electric')">
                                                <i class="bi bi-lightning me-2"></i>
                                                <span>Điện sinh hoạt</span>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-3 col-sm-6 mb-2">
                                            <div class="service-template-item" onclick="selectServiceTemplate('water')">
                                                <i class="bi bi-droplet me-2"></i>
                                                <span>Nước sinh hoạt</span>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-3 col-sm-6 mb-2">
                                            <div class="service-template-item" onclick="selectServiceTemplate('internet')">
                                                <i class="bi bi-wifi me-2"></i>
                                                <span>Internet WiFi</span>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-3 col-sm-6 mb-2">
                                            <div class="service-template-item" onclick="selectServiceTemplate('cleaning')">
                                                <i class="bi bi-brush me-2"></i>
                                                <span>Vệ sinh chung</span>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-3 col-sm-6 mb-2">
                                            <div class="service-template-item" onclick="selectServiceTemplate('parking')">
                                                <i class="bi bi-car-front me-2"></i>
                                                <span>Gửi xe máy</span>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-3 col-sm-6 mb-2">
                                            <div class="service-template-item" onclick="selectServiceTemplate('cable')">
                                                <i class="bi bi-tv me-2"></i>
                                                <span>Cáp truyền hình</span>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-3 col-sm-6 mb-2">
                                            <div class="service-template-item" onclick="selectServiceTemplate('security')">
                                                <i class="bi bi-shield-check me-2"></i>
                                                <span>An ninh 24/7</span>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-3 col-sm-6 mb-2">
                                            <div class="service-template-item" onclick="selectServiceTemplate('maintenance')">
                                                <i class="bi bi-tools me-2"></i>
                                                <span>Bảo trì định kỳ</span>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Dịch vụ tùy chọn -->
                                    <div class="mt-3">
                                        <label for="customService" class="form-label">
                                            <i class="bi bi-plus-circle me-1"></i>
                                            Dịch vụ khác (tùy chọn)
                                        </label>
                                        <div class="input-group">
                                            <input type="text" 
                                                   class="form-control" 
                                                   id="customService" 
                                                   placeholder="Nhập tên dịch vụ khác..." 
                                                   maxlength="100">
                                            <button type="button" 
                                                    class="btn btn-outline-primary" 
                                                    onclick="addCustomService()">
                                                <i class="bi bi-plus"></i>
                                                Chọn
                                            </button>
                                        </div>
                                        <div class="form-text">Ví dụ: Giặt ủi, Dịch vụ phòng, Tháng máy...</div>
                                    </div>
                                    
                                    <!-- Hiển thị dịch vụ đã chọn -->
                                    <div class="mt-3" id="selectedService" style="display: none;">
                                        <h6 class="text-primary">Dịch vụ đã chọn:</h6>
                                        <div id="serviceDisplay" class="d-flex flex-wrap gap-2"></div>
                                    </div>
                                </div>
                                
                                <!-- Tầng 2: Chọn Loại dịch vụ -->
                                <div class="service-type-section mb-4">
                                    <h6 class="mb-3">
                                        <i class="bi bi-tags me-2"></i>
                                        Loại dịch vụ:
                                    </h6>
                                    <div class="row">
                                        <div class="col-md-6 col-lg-4 mb-2">
                                            <div class="form-check service-type-option">
                                                <input class="form-check-input" type="radio" name="serviceType" id="typeFree" value="FREE" onchange="onServiceTypeChange()">
                                                <label class="form-check-label" for="typeFree">
                                                    <i class="bi bi-gift me-2"></i>
                                                    <strong>🆓 Miễn phí</strong>
                                                    <br><small class="text-muted">Không tính phí</small>
                                                </label>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-6 col-lg-4 mb-2">
                                            <div class="form-check service-type-option">
                                                <input class="form-check-input" type="radio" name="serviceType" id="typeMonthly" value="MONTHLY" onchange="onServiceTypeChange()" checked>
                                                <label class="form-check-label" for="typeMonthly">
                                                    <i class="bi bi-calendar me-2"></i>
                                                    <strong>📅 Theo tháng</strong>
                                                    <br><small class="text-muted">Giá cố định/tháng</small>
                                                </label>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-6 col-lg-4 mb-2">
                                            <div class="form-check service-type-option">
                                                <input class="form-check-input" type="radio" name="serviceType" id="typeMeter" value="METER_READING" onchange="onServiceTypeChange()">
                                                <label class="form-check-label" for="typeMeter">
                                                    <i class="bi bi-speedometer me-2"></i>
                                                    <strong>📊 Theo chỉ số</strong>
                                                    <br><small class="text-muted">Điện, nước</small>
                                                </label>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-6 col-lg-4 mb-2">
                                            <div class="form-check service-type-option">
                                                <input class="form-check-input" type="radio" name="serviceType" id="typePerson" value="PER_PERSON" onchange="onServiceTypeChange()">
                                                <label class="form-check-label" for="typePerson">
                                                    <i class="bi bi-people me-2"></i>
                                                    <strong>👥 Theo đầu người</strong>
                                                    <br><small class="text-muted">Vệ sinh, rác thải</small>
                                                </label>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-6 col-lg-4 mb-2">
                                            <div class="form-check service-type-option">
                                                <input class="form-check-input" type="radio" name="serviceType" id="typeRoom" value="PER_ROOM" onchange="onServiceTypeChange()">
                                                <label class="form-check-label" for="typeRoom">
                                                    <i class="bi bi-house me-2"></i>
                                                    <strong>🏠 Theo phòng</strong>
                                                    <br><small class="text-muted">Gửi xe, dịch vụ phòng</small>
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Tầng 3: Cấu hình Chi tiết (Dynamic) -->
                                <div id="serviceConfigSection">
                                    <!-- Nội dung sẽ thay đổi theo loại dịch vụ -->
                                </div>
                                
                                <!-- Hidden inputs -->
                                <input type="hidden" name="serviceName" id="serviceNameHidden" value="">
                                <input type="hidden" name="calculationConfig" id="calculationConfigHidden" value="">
                                

                                
                                <div class="d-flex justify-content-between">
                                    <a href="${pageContext.request.contextPath}/admin/services" 
                                       class="btn btn-secondary">
                                        <i class="bi bi-arrow-left me-1"></i>
                                        Quay lại
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <c:choose>
                                            <c:when test="${action == 'add'}">
                                                <i class="bi bi-plus-circle me-1"></i>
                                                Thêm Dịch vụ
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
        // ==================== BIẾN TOÀN CỤC ====================
        
        let selectedServiceName = '';
        let currentServiceType = 'MONTHLY';
        let tieredPricingTiers = [];
        
        // Service templates data
        const serviceTemplates = {
            'electric': {
                name: 'Điện sinh hoạt',
                type: 'METER_READING',
                unit: 'kWh',
                price: 0,
                config: {
                    type: 'TIERED_PRICING',
                    tiers: [
                        {from: 0, to: 50, price: 1500},
                        {from: 51, to: 100, price: 2000},
                        {from: 101, to: null, price: 2500}
                    ]
                },

            },
            'water': {
                name: 'Nước sinh hoạt',
                type: 'METER_READING',
                unit: 'm³',
                price: 25000,
                config: {type: 'FIXED_PRICE', price: 25000},

            },
            'internet': {
                name: 'Internet WiFi',
                type: 'MONTHLY',
                unit: 'tháng',
                price: 100000,
                config: {type: 'FIXED_PRICE', price: 100000},

            },
            'cleaning': {
                name: 'Vệ sinh chung',
                type: 'PER_PERSON',
                unit: 'người',
                price: 30000,
                config: {type: 'FIXED_PRICE', price: 30000},

            },
            'parking': {
                name: 'Gửi xe máy',
                type: 'PER_ROOM',
                unit: 'phòng',
                price: 20000,
                config: {type: 'FIXED_PRICE', price: 20000},

            },
            'cable': {
                name: 'Cáp truyền hình',
                type: 'MONTHLY',
                unit: 'tháng',
                price: 80000,
                config: {type: 'FIXED_PRICE', price: 80000},

            },
            'security': {
                name: 'An ninh 24/7',
                type: 'MONTHLY',
                unit: 'tháng',
                price: 50000,
                config: {type: 'FIXED_PRICE', price: 50000},

            },
            'maintenance': {
                name: 'Bảo trì định kỳ',
                type: 'MONTHLY',
                unit: 'tháng',
                price: 30000,
                config: {type: 'FIXED_PRICE', price: 30000},

            }
        };
        
        // ==================== INITIALIZATION ====================
        
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize form
            onServiceTypeChange(); // Load default config
            
            // Handle Enter key in custom service input
            document.getElementById('customService').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    addCustomService();
                }
            });
        });
        
        // ==================== SERVICE TEMPLATE FUNCTIONS ====================
        
        function selectServiceTemplate(templateKey) {
            const template = serviceTemplates[templateKey];
            if (!template) return;
            
            // Clear previous selections
            document.querySelectorAll('.service-template-item').forEach(item => {
                item.classList.remove('selected');
            });
            
            // Mark as selected
            event.target.closest('.service-template-item').classList.add('selected');
            
            // Set service name
            selectedServiceName = template.name;
            
            // Set service type
            let typeId = 'type';
            if (template.type === 'FREE') typeId += 'Free';
            else if (template.type === 'MONTHLY') typeId += 'Monthly';
            else if (template.type === 'METER_READING') typeId += 'Meter';
            else if (template.type === 'PER_PERSON') typeId += 'Person';
            else if (template.type === 'PER_ROOM') typeId += 'Room';
            
            const typeRadio = document.getElementById(typeId);
            if (typeRadio) typeRadio.checked = true;
            currentServiceType = template.type;
            
            // Update display
            updateSelectedServiceDisplay();
            onServiceTypeChange();
            
            // Pre-fill configuration if available
            if (template.config) {
                setTimeout(() => {
                    fillTemplateConfig(template);
                }, 100);
            }
        }
        
        function addCustomService() {
            const input = document.getElementById('customService');
            const value = input.value.trim();
            
            if (value) {
                // Clear template selections
                document.querySelectorAll('.service-template-item').forEach(item => {
                    item.classList.remove('selected');
                });
                
                selectedServiceName = value;
                input.value = '';
                updateSelectedServiceDisplay();
            }
        }
        
        function updateSelectedServiceDisplay() {
            const container = document.getElementById('selectedService');
            const display = document.getElementById('serviceDisplay');
            
            if (selectedServiceName) {
                container.style.display = 'block';
                display.innerHTML = 
                    '<span class="badge bg-primary" style="font-size: 1em; padding: 8px 12px;">' +
                        '<i class="bi bi-check-circle me-1"></i>' +
                        selectedServiceName +
                        '<button type="button" class="btn-close btn-close-white ms-2" ' +
                                'onclick="clearSelectedService()" ' +
                                'style="font-size: 0.8em;"></button>' +
                    '</span>';
                
                // Update hidden input
                document.getElementById('serviceNameHidden').value = selectedServiceName;
            } else {
                container.style.display = 'none';
            }
        }
        
        function clearSelectedService() {
            selectedServiceName = '';
            document.querySelectorAll('.service-template-item').forEach(item => {
                item.classList.remove('selected');
            });
            updateSelectedServiceDisplay();
        }
        // ==================== SERVICE TYPE FUNCTIONS ====================
        
        function onServiceTypeChange() {
            const selectedType = document.querySelector('input[name="serviceType"]:checked').value;
            currentServiceType = selectedType;
            
            const configSection = document.getElementById('serviceConfigSection');
            
            switch(selectedType) {
                case 'FREE':
                    configSection.innerHTML = generateFreeConfig();
                    break;
                case 'MONTHLY':
                    configSection.innerHTML = generateMonthlyConfig();
                    break;
                case 'METER_READING':
                    configSection.innerHTML = generateMeterReadingConfig();
                    break;
                case 'PER_PERSON':
                    configSection.innerHTML = generatePerPersonConfig();
                    break;
                case 'PER_ROOM':
                    configSection.innerHTML = generatePerRoomConfig();
                    break;
            }
        }
        
        function generateFreeConfig() {
            return `
                <div class="config-section active">
                    <div class="alert alert-success">
                        <i class="bi bi-check-circle me-2"></i>
                        <strong>Dịch vụ miễn phí</strong> - Không cần cấu hình thêm
                    </div>
                    <input type="hidden" name="unit" value="">
                    <input type="hidden" name="pricePerUnit" value="0">
                </div>
            `;
        }
        
        function generateMonthlyConfig() {
            return `
                <div class="config-section active">
                    <h6 class="text-primary mb-3">
                        <i class="bi bi-calendar me-2"></i>
                        Cấu hình dịch vụ theo tháng
                    </h6>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="monthlyPrice" class="form-label">
                                <i class="bi bi-currency-dollar me-1"></i>
                                Giá cố định <span class="required">*</span>
                            </label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="monthlyPrice" 
                                       name="pricePerUnit" placeholder="100000" required min="1">
                                <span class="input-group-text">VNĐ/tháng</span>
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="monthlyUnit" class="form-label">
                                <i class="bi bi-rulers me-1"></i>
                                Đơn vị
                            </label>
                            <input type="text" class="form-control" id="monthlyUnit" 
                                   name="unit" value="tháng" readonly>
                        </div>
                    </div>

                </div>
            `;
        }
        
        function generateMeterReadingConfig() {
            return `
                <div class="config-section active">
                    <h6 class="text-primary mb-3">
                        <i class="bi bi-speedometer me-2"></i>
                        Cấu hình dịch vụ theo chỉ số
                    </h6>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="meterUnit" class="form-label">
                                <i class="bi bi-rulers me-1"></i>
                                Đơn vị tính <span class="required">*</span>
                            </label>
                            <select class="form-select" id="meterUnit" name="unit" required>
                                <option value="">Chọn đơn vị...</option>
                                <option value="kWh">kWh (Điện)</option>
                                <option value="m³">m³ (Nước)</option>
                                <option value="m³">m³ (Gas)</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">
                                <i class="bi bi-calculator me-1"></i>
                                Cách tính giá
                            </label>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="pricingType" 
                                       id="fixedPricing" value="fixed" onchange="togglePricingType()" checked>
                                <label class="form-check-label" for="fixedPricing">
                                    Đơn giá cố định
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="pricingType" 
                                       id="tieredPricing" value="tiered" onchange="togglePricingType()">
                                <label class="form-check-label" for="tieredPricing">
                                    Bậc thang (khuyến nghị cho điện)
                                </label>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Fixed Pricing -->
                    <div id="fixedPricingSection">
                        <div class="mb-3">
                            <label for="fixedPrice" class="form-label">
                                <i class="bi bi-currency-dollar me-1"></i>
                                Đơn giá <span class="required">*</span>
                            </label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="fixedPrice" 
                                       name="pricePerUnit" placeholder="3500" required min="1">
                                <span class="input-group-text">VNĐ/đơn vị</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Tiered Pricing -->
                    <div id="tieredPricingSection" style="display: none;">
                        <div class="mb-3">
                            <label class="form-label">
                                <i class="bi bi-bar-chart-steps me-1"></i>
                                Bậc giá
                            </label>
                            <div id="tiersContainer">
                                <!-- Tiers will be added here -->
                            </div>
                            <button type="button" class="add-tier-btn" onclick="addTier()">
                                <i class="bi bi-plus-circle me-1"></i>
                                Thêm bậc giá
                            </button>
                        </div>
                        <input type="hidden" name="pricePerUnit" value="0">
                    </div>
                    

                </div>
            `;
        }
        
        function generatePerPersonConfig() {
            return `
                <div class="config-section active">
                    <h6 class="text-primary mb-3">
                        <i class="bi bi-people me-2"></i>
                        Cấu hình dịch vụ theo đầu người
                    </h6>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="personPrice" class="form-label">
                                <i class="bi bi-currency-dollar me-1"></i>
                                Giá mỗi người <span class="required">*</span>
                            </label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="personPrice" 
                                       name="pricePerUnit" placeholder="30000" required min="1">
                                <span class="input-group-text">VNĐ/người/tháng</span>
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="personUnit" class="form-label">
                                <i class="bi bi-rulers me-1"></i>
                                Đơn vị
                            </label>
                            <input type="text" class="form-control" id="personUnit" 
                                   name="unit" value="người" readonly>
                        </div>
                    </div>

                </div>
            `;
        }
        
        function generatePerRoomConfig() {
            return `
                <div class="config-section active">
                    <h6 class="text-primary mb-3">
                        <i class="bi bi-house me-2"></i>
                        Cấu hình dịch vụ theo phòng
                    </h6>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="roomPrice" class="form-label">
                                <i class="bi bi-currency-dollar me-1"></i>
                                Giá mỗi phòng <span class="required">*</span>
                            </label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="roomPrice" 
                                       name="pricePerUnit" placeholder="20000" required min="1">
                                <span class="input-group-text">VNĐ/phòng/tháng</span>
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="roomUnit" class="form-label">
                                <i class="bi bi-rulers me-1"></i>
                                Đơn vị
                            </label>
                            <input type="text" class="form-control" id="roomUnit" 
                                   name="unit" value="phòng" readonly>
                        </div>
                    </div>

                </div>
            `;
        }
        
        // ==================== TIERED PRICING FUNCTIONS ====================
        
        function togglePricingType() {
            const isFixed = document.getElementById('fixedPricing').checked;
            const fixedSection = document.getElementById('fixedPricingSection');
            const tieredSection = document.getElementById('tieredPricingSection');
            
            if (isFixed) {
                fixedSection.style.display = 'block';
                tieredSection.style.display = 'none';
                tieredPricingTiers = [];
            } else {
                fixedSection.style.display = 'none';
                tieredSection.style.display = 'block';
                
                // Initialize with default tiers for electricity
                if (tieredPricingTiers.length === 0) {
                    tieredPricingTiers = [
                        {from: 0, to: 50, price: 1500},
                        {from: 51, to: 100, price: 2000},
                        {from: 101, to: null, price: 2500}
                    ];
                }
                renderTiers();
            }
        }
        
        function addTier() {
            const lastTier = tieredPricingTiers[tieredPricingTiers.length - 1];
            const newFrom = lastTier ? (lastTier.to ? lastTier.to + 1 : 201) : 0;
            
            tieredPricingTiers.push({
                from: newFrom,
                to: null,
                price: 0
            });
            
            renderTiers();
        }
        
        function removeTier(index) {
            if (tieredPricingTiers.length > 1) {
                tieredPricingTiers.splice(index, 1);
                renderTiers();
            }
        }
        
        function renderTiers() {
            const container = document.getElementById('tiersContainer');
            if (!container) return;
            
            let html = '';
            for (let i = 0; i < tieredPricingTiers.length; i++) {
                const tier = tieredPricingTiers[i];
                const isFirstTier = (i === 0);
                const isOnlyTier = (tieredPricingTiers.length <= 1);
                
                html += `
                    <div class="tier-row">
                        <div class="row align-items-center">
                            <div class="col-md-3">
                                <label class="form-label">Từ</label>
                                <input type="number" class="form-control" 
                                       value="` + tier.from + `" 
                                       onchange="updateTier(` + i + `, 'from', this.value)"
                                       ` + (isFirstTier ? 'readonly' : '') + `>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Đến</label>
                                <input type="number" class="form-control" 
                                       value="` + (tier.to || '') + `" 
                                       placeholder="Không giới hạn"
                                       onchange="updateTier(` + i + `, 'to', this.value)">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Giá (VNĐ)</label>
                                <input type="number" class="form-control" 
                                       value="` + tier.price + `" 
                                       onchange="updateTier(` + i + `, 'price', this.value)"
                                       required>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">&nbsp;</label>
                                <button type="button" class="btn btn-outline-danger w-100" 
                                        onclick="removeTier(` + i + `)"
                                        ` + (isOnlyTier ? 'disabled' : '') + `>
                                    <i class="bi bi-trash"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                `;
            }
            container.innerHTML = html;
        }
        
        function updateTier(index, field, value) {
            if (field === 'to' && value === '') {
                tieredPricingTiers[index][field] = null;
            } else {
                tieredPricingTiers[index][field] = parseInt(value) || 0;
            }
        }
        
        // ==================== TEMPLATE CONFIG FUNCTIONS ====================
        
        function fillTemplateConfig(template) {
            // Set service type radio
            const typeRadio = document.querySelector(`input[name="serviceType"][value="${template.type}"]`);
            if (typeRadio) {
                typeRadio.checked = true;
                onServiceTypeChange();
            }
            
            // Fill configuration based on type
            setTimeout(() => {
                switch(template.type) {
                    case 'METER_READING':
                        if (template.unit) {
                            const unitSelect = document.getElementById('meterUnit');
                            if (unitSelect) unitSelect.value = template.unit;
                        }
                        
                        if (template.config.type === 'TIERED_PRICING') {
                            document.getElementById('tieredPricing').checked = true;
                            tieredPricingTiers = template.config.tiers;
                            togglePricingType();
                        } else {
                            document.getElementById('fixedPricing').checked = true;
                            const priceInput = document.getElementById('fixedPrice');
                            if (priceInput) priceInput.value = template.price;
                        }
                        break;
                        
                    case 'MONTHLY':
                        const monthlyPrice = document.getElementById('monthlyPrice');
                        if (monthlyPrice) monthlyPrice.value = template.price;
                        break;
                        
                    case 'PER_PERSON':
                        const personPrice = document.getElementById('personPrice');
                        if (personPrice) personPrice.value = template.price;
                        break;
                        
                    case 'PER_ROOM':
                        const roomPrice = document.getElementById('roomPrice');
                        if (roomPrice) roomPrice.value = template.price;
                        break;
                }
                

            }, 200);
        }
        
        // ==================== FORM VALIDATION ====================
        
        document.getElementById('serviceForm').addEventListener('submit', function(e) {
            // Validate service name
            if (!selectedServiceName.trim()) {
                e.preventDefault();
                alert('Vui lòng chọn hoặc nhập tên dịch vụ');
                return false;
            }
            
            // Update hidden inputs
            document.getElementById('serviceNameHidden').value = selectedServiceName;
            
            // Generate calculation config
            const config = generateCalculationConfig();
            document.getElementById('calculationConfigHidden').value = JSON.stringify(config);
            
            return true;
        });
        
        function generateCalculationConfig() {
            switch(currentServiceType) {
                case 'FREE':
                    return {type: 'FREE'};
                    
                case 'MONTHLY':
                case 'PER_PERSON':
                case 'PER_ROOM':
                    const price = document.querySelector('input[name="pricePerUnit"]').value;
                    return {type: 'FIXED_PRICE', price: parseInt(price)};
                    
                case 'METER_READING':
                    const isFixed = document.getElementById('fixedPricing').checked;
                    if (isFixed) {
                        const price = document.getElementById('fixedPrice').value;
                        return {type: 'FIXED_PRICE', price: parseInt(price)};
                    } else {
                        return {type: 'TIERED_PRICING', tiers: tieredPricingTiers};
                    }
                    
                default:
                    return {type: 'FIXED_PRICE', price: 0};
            }
        }
    </script>
</body>
</html>
