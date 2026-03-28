import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  bool _loginPasswordVisible = false;
  bool _registerPasswordVisible = false;
  String _selectedRole = 'Kullanıcı';

  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  final _registerNameController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();

  final List<String> _roles = ['Kullanıcı', 'Araştırmacı', 'Yönetici'];

  // Mock credentials
  static const Map<String, Map<String, String>> _mockCredentials = {
    'Kullanıcı': {
      'email': 'kullanici@ekodost.com',
      'password': 'Kullanici123!',
    },
    'Araştırmacı': {
      'email': 'arastirmaci@ekodost.com',
      'password': 'Arastirma123!',
    },
    'Yönetici': {'email': 'yonetici@ekodost.com', 'password': 'Yonetici123!'},
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerNameController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!(_loginFormKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    setState(() => _isLoading = false);

    bool validCredentials = false;
    for (final role in _mockCredentials.keys) {
      if (_loginEmailController.text.trim() ==
              _mockCredentials[role]!['email'] &&
          _loginPasswordController.text ==
              _mockCredentials[role]!['password']) {
        validCredentials = true;
        break;
      }
    }

    if (!mounted) return;

    if (validCredentials) {
      HapticFeedback.lightImpact();
      Navigator.of(
        context,
        rootNavigator: true,
      ).pushNamed('/real-time-dashboard-screen');
    } else {
      _showErrorDialog(
        'Geçersiz kimlik bilgileri.\n\nDemo hesapları:\n'
        '• kullanici@ekodost.com / Kullanici123!\n'
        '• arastirmaci@ekodost.com / Arastirma123!\n'
        '• yonetici@ekodost.com / Yonetici123!',
      );
    }
  }

  Future<void> _handleRegister() async {
    if (!(_registerFormKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    setState(() => _isLoading = false);
    if (!mounted) return;
    HapticFeedback.lightImpact();
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('/household-profile-setup-screen');
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Giriş Hatası',
          style: GoogleFonts.inter(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          message,
          style: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Tamam',
              style: GoogleFonts.inter(color: AppTheme.primaryAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _showForgotPassword() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _ForgotPasswordSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                children: [
                  SizedBox(height: 2.h),
                  _LogoSection(),
                  SizedBox(height: 3.h),
                  _TabSwitcher(tabController: _tabController),
                  SizedBox(height: 2.h),
                  SizedBox(
                    height: 52.h,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _LoginForm(
                          formKey: _loginFormKey,
                          emailController: _loginEmailController,
                          passwordController: _loginPasswordController,
                          passwordVisible: _loginPasswordVisible,
                          isLoading: _isLoading,
                          onTogglePassword: () => setState(
                            () =>
                                _loginPasswordVisible = !_loginPasswordVisible,
                          ),
                          onLogin: _handleLogin,
                          onForgotPassword: _showForgotPassword,
                        ),
                        _RegisterForm(
                          formKey: _registerFormKey,
                          nameController: _registerNameController,
                          emailController: _registerEmailController,
                          passwordController: _registerPasswordController,
                          passwordVisible: _registerPasswordVisible,
                          isLoading: _isLoading,
                          selectedRole: _selectedRole,
                          roles: _roles,
                          onTogglePassword: () => setState(
                            () => _registerPasswordVisible =
                                !_registerPasswordVisible,
                          ),
                          onRoleChanged: (val) => setState(
                            () => _selectedRole = val ?? 'Kullanıcı',
                          ),
                          onRegister: _handleRegister,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  _SocialLoginSection(),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 18.w,
          height: 18.w,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primaryAccent, Color(0xFF007A62)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryAccent.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'bolt',
              color: AppTheme.primaryBackground,
              size: 32,
            ),
          ),
        ),
        SizedBox(height: 1.5.h),
        Text(
          'EkoDost',
          style: GoogleFonts.inter(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          'Akıllı Enerji Tasarrufu',
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            color: AppTheme.textSecondary,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

class _TabSwitcher extends StatelessWidget {
  final TabController tabController;
  const _TabSwitcher({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: tabController,
        indicator: BoxDecoration(
          color: AppTheme.primaryAccent,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppTheme.primaryBackground,
        unselectedLabelColor: AppTheme.textSecondary,
        labelStyle: GoogleFonts.inter(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
        ),
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Giriş Yap'),
          Tab(text: 'Kayıt Ol'),
        ],
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool passwordVisible;
  final bool isLoading;
  final VoidCallback onTogglePassword;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;

  const _LoginForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.passwordVisible,
    required this.isLoading,
    required this.onTogglePassword,
    required this.onLogin,
    required this.onForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AuthTextField(
            controller: emailController,
            label: 'E-posta',
            hint: 'ornek@email.com',
            keyboardType: TextInputType.emailAddress,
            prefixIconName: 'email',
            validator: (v) {
              if (v == null || v.isEmpty) return 'E-posta gerekli';
              if (!v.contains('@')) return 'Geçerli bir e-posta girin';
              return null;
            },
          ),
          SizedBox(height: 1.5.h),
          _AuthTextField(
            controller: passwordController,
            label: 'Şifre',
            hint: '••••••••',
            obscureText: !passwordVisible,
            prefixIconName: 'lock',
            suffixIconName: passwordVisible ? 'visibility' : 'visibility_off',
            onSuffixTap: onTogglePassword,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Şifre gerekli';
              if (v.length < 6) return 'En az 6 karakter';
              return null;
            },
          ),
          SizedBox(height: 1.h),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onForgotPassword,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Şifremi Unuttum',
                style: GoogleFonts.inter(
                  color: AppTheme.primaryAccent,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          _AuthButton(
            label: 'Giriş Yap',
            isLoading: isLoading,
            onPressed: onLogin,
          ),
        ],
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool passwordVisible;
  final bool isLoading;
  final String selectedRole;
  final List<String> roles;
  final VoidCallback onTogglePassword;
  final ValueChanged<String?> onRoleChanged;
  final VoidCallback onRegister;

  const _RegisterForm({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.passwordVisible,
    required this.isLoading,
    required this.selectedRole,
    required this.roles,
    required this.onTogglePassword,
    required this.onRoleChanged,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AuthTextField(
            controller: nameController,
            label: 'Ad Soyad',
            hint: 'Adınız Soyadınız',
            prefixIconName: 'person',
            validator: (v) {
              if (v == null || v.isEmpty) return 'Ad soyad gerekli';
              return null;
            },
          ),
          SizedBox(height: 1.5.h),
          _AuthTextField(
            controller: emailController,
            label: 'E-posta',
            hint: 'ornek@email.com',
            keyboardType: TextInputType.emailAddress,
            prefixIconName: 'email',
            validator: (v) {
              if (v == null || v.isEmpty) return 'E-posta gerekli';
              if (!v.contains('@')) return 'Geçerli bir e-posta girin';
              return null;
            },
          ),
          SizedBox(height: 1.5.h),
          _AuthTextField(
            controller: passwordController,
            label: 'Şifre',
            hint: '••••••••',
            obscureText: !passwordVisible,
            prefixIconName: 'lock',
            suffixIconName: passwordVisible ? 'visibility' : 'visibility_off',
            onSuffixTap: onTogglePassword,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Şifre gerekli';
              if (v.length < 6) return 'En az 6 karakter';
              return null;
            },
          ),
          SizedBox(height: 1.5.h),
          _RoleDropdown(
            selectedRole: selectedRole,
            roles: roles,
            onChanged: onRoleChanged,
          ),
          SizedBox(height: 2.h),
          _AuthButton(
            label: 'Kayıt Ol',
            isLoading: isLoading,
            onPressed: onRegister,
          ),
        ],
      ),
    );
  }
}

class _AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final bool obscureText;
  final String prefixIconName;
  final String? suffixIconName;
  final VoidCallback? onSuffixTap;
  final String? Function(String?)? validator;

  const _AuthTextField({
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    required this.prefixIconName,
    this.suffixIconName,
    this.onSuffixTap,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: GoogleFonts.inter(color: AppTheme.textPrimary, fontSize: 13.sp),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: GoogleFonts.inter(color: AppTheme.textSecondary),
        hintStyle: GoogleFonts.inter(
          color: AppTheme.textSecondary.withValues(alpha: 0.5),
        ),
        fillColor: AppTheme.surfaceCard,
        filled: true,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12),
          child: CustomIconWidget(
            iconName: prefixIconName,
            color: AppTheme.textSecondary,
            size: 20,
          ),
        ),
        suffixIcon: suffixIconName != null
            ? GestureDetector(
                onTap: onSuffixTap,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: CustomIconWidget(
                    iconName: suffixIconName!,
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.dividerSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.dividerSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryAccent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFCF6679)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFCF6679), width: 2),
        ),
        errorStyle: GoogleFonts.inter(fontSize: 10.sp),
      ),
      validator: validator,
      textInputAction: TextInputAction.next,
    );
  }
}

class _RoleDropdown extends StatelessWidget {
  final String selectedRole;
  final List<String> roles;
  final ValueChanged<String?> onChanged;

  const _RoleDropdown({
    required this.selectedRole,
    required this.roles,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.dividerSubtle),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedRole,
          isExpanded: true,
          dropdownColor: AppTheme.surfaceCard,
          icon: CustomIconWidget(
            iconName: 'keyboard_arrow_down',
            color: AppTheme.textSecondary,
            size: 22,
          ),
          items: roles
              .map(
                (r) => DropdownMenuItem(
                  value: r,
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: r == 'Kullanıcı'
                            ? 'person'
                            : r == 'Araştırmacı'
                            ? 'science'
                            : 'admin_panel_settings',
                        color: AppTheme.primaryAccent,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        r,
                        style: GoogleFonts.inter(
                          color: AppTheme.textPrimary,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
          hint: Row(
            children: [
              CustomIconWidget(
                iconName: 'person',
                color: AppTheme.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'Rol Seçin',
                style: GoogleFonts.inter(
                  color: AppTheme.textSecondary,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  const _AuthButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 6.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryAccent,
          foregroundColor: AppTheme.primaryBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          shadowColor: AppTheme.primaryAccent.withValues(alpha: 0.4),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryBackground,
                  ),
                ),
              )
            : Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}

class _SocialLoginSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: AppTheme.dividerSubtle)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'veya',
                style: GoogleFonts.inter(
                  color: AppTheme.textSecondary,
                  fontSize: 11.sp,
                ),
              ),
            ),
            Expanded(child: Divider(color: AppTheme.dividerSubtle)),
          ],
        ),
        SizedBox(height: 1.5.h),
        Row(
          children: [
            Expanded(
              child: _SocialButton(
                label: 'Google',
                iconName: 'g_mobiledata',
                color: const Color(0xFFEA4335),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _SocialButton(
                label: 'Apple',
                iconName: 'apple',
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final String iconName;
  final Color color;

  const _SocialButton({
    required this.label,
    required this.iconName,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: AppTheme.dividerSubtle),
        backgroundColor: AppTheme.surfaceCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(iconName: iconName, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              color: AppTheme.textPrimary,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ForgotPasswordSheet extends StatelessWidget {
  final _emailController = TextEditingController();

  _ForgotPasswordSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        4.w,
        2.h,
        4.w,
        MediaQuery.of(context).viewInsets.bottom + 2.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.dividerSubtle,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Şifremi Sıfırla',
            style: GoogleFonts.inter(
              color: AppTheme.textPrimary,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'E-posta adresinize sıfırlama bağlantısı göndereceğiz.',
            style: GoogleFonts.inter(
              color: AppTheme.textSecondary,
              fontSize: 11.sp,
            ),
          ),
          SizedBox(height: 2.h),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.inter(
              color: AppTheme.textPrimary,
              fontSize: 13.sp,
            ),
            decoration: InputDecoration(
              labelText: 'E-posta',
              labelStyle: GoogleFonts.inter(color: AppTheme.textSecondary),
              fillColor: AppTheme.primaryBackground,
              filled: true,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12),
                child: CustomIconWidget(
                  iconName: 'email',
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.dividerSubtle),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.dividerSubtle),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppTheme.primaryAccent,
                  width: 2,
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Sıfırlama bağlantısı gönderildi!',
                    style: GoogleFonts.inter(color: AppTheme.textPrimary),
                  ),
                  backgroundColor: AppTheme.surfaceCard,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryAccent,
              foregroundColor: AppTheme.primaryBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(vertical: 1.8.h),
            ),
            child: Text(
              'Gönder',
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
