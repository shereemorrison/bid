// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../providers/supabase_auth_provider.dart';
// import '../../components/common_widgets/custom_textfield.dart';
// import '../../components/buttons/custom_button.dart';
// import '../../services/newsletter_service.dart';
//
// class RegisterForm extends ConsumerStatefulWidget {
//   final VoidCallback? onRegisterSuccess;
//   final VoidCallback? onCancel;
//   final VoidCallback? onLoginInstead;
//   final bool showBackButton;
//
//   const RegisterForm({
//     Key? key,
//     this.onRegisterSuccess,
//     this.onCancel,
//     this.onLoginInstead,
//     this.showBackButton = false,
//   }) : super(key: key);
//
//   @override
//   ConsumerState<RegisterForm> createState() => _RegisterFormState();
// }
//
// class _RegisterFormState extends ConsumerState<RegisterForm> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController firstNameController = TextEditingController();
//   final TextEditingController lastNameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPwController = TextEditingController();
//   bool _isLoading = false;
//   String? _errorMessage;
//   bool _subscribeToNewsletter = false;
//   final NewsletterService _newsletterService = NewsletterService();
//
//   @override
//   void dispose() {
//     firstNameController.dispose();
//     lastNameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     confirmPwController.dispose();
//     super.dispose();
//   }
//
//   Future<void> register() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
//
//     setState(() {
//       _errorMessage = null;
//       _isLoading = true;
//     });
//
//     try {
//       // Register the user with Supabase
//       await ref.read(authNotifierProvider.notifier).signUp(
//         emailController.text.trim(),
//         passwordController.text.trim(),
//         firstName: firstNameController.text.trim(),
//         lastName: lastNameController.text.trim(),
//       );
//
//       if (_subscribeToNewsletter) {
//         try {
//           // Get user ID if available
//           String? userId = ref.read(authUserIdProvider);
//
//           // Subscribe to newsletter
//           await _newsletterService.subscribeToNewsletter(
//             emailController.text.trim(),
//             userId: userId,
//           );
//         } catch (e) {
//           // Don't block registration if newsletter subscription fails
//           print('Newsletter subscription failed: ${e.toString()}');
//         }
//       }
//
//       if (mounted) {
//         if (widget.onRegisterSuccess != null) {
//           widget.onRegisterSuccess!();
//         } else {
//           Navigator.of(context).pop();
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   side: BorderSide(
//                     color: Theme.of(context).colorScheme.primary,
//                     width: 2,
//                   ),
//                 ),
//                 backgroundColor: Theme.of(context).colorScheme.primary,
//                 title: Text(
//                   'Welcome to B.I.D.${firstNameController.text.isNotEmpty ? ', ${firstNameController.text}' : ''}',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
//                 ),
//                 content: Text(
//                   'You have successfully registered',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Theme.of(context).colorScheme.surface),
//                 ),
//                 actions: <Widget>[
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: Text(
//                       'OK',
//                       style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           );
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _errorMessage = "Error registering: ${e.toString()}";
//           _isLoading = false;
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.9,
//       constraints: BoxConstraints(
//         maxWidth: 600,
//         maxHeight: MediaQuery.of(context).size.height * 0.8,
//       ),
//       child: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 if (widget.showBackButton && widget.onCancel != null)
//                   Align(
//                     alignment: Alignment.topLeft,
//                     child: IconButton(
//                       icon: const Icon(Icons.arrow_back),
//                       onPressed: widget.onCancel,
//                     ),
//                   ),
//
//                 Text(
//                   "Sign Up",
//                   style: TextStyle(color: Theme.of(context).colorScheme.secondary),
//                 ),
//                 Icon(
//                   Icons.person,
//                   size: 60,
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//
//                 const SizedBox(height: 25),
//
//                 Text(
//                   "BELIEVE  IN  DREAMS",
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: Theme.of(context).colorScheme.secondary,
//                   ),
//                 ),
//
//                 const SizedBox(height: 40),
//
//                 Row(
//                   children: [
//                     Expanded(
//                       child: MyTextField(
//                         hintText: "First Name",
//                         obscureText: false,
//                         controller: firstNameController,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your first name';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: MyTextField(
//                         hintText: "Last Name",
//                         obscureText: false,
//                         controller: lastNameController,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your last name';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 MyTextField(
//                   hintText: "Email",
//                   obscureText: false,
//                   controller: emailController,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your email';
//                     }
//                     if (!value.contains('@') || !value.contains('.')) {
//                       return 'Please enter a valid email';
//                     }
//                     return null;
//                   },
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 MyTextField(
//                   hintText: "Enter Password",
//                   obscureText: true,
//                   controller: passwordController,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a password';
//                     }
//                     if (value.length < 6) {
//                       return 'Password must be at least 6 characters';
//                     }
//                     return null;
//                   },
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 MyTextField(
//                   hintText: "Confirm Password",
//                   obscureText: true,
//                   controller: confirmPwController,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please confirm your password';
//                     }
//                     if (value != passwordController.text) {
//                       return 'Passwords do not match';
//                     }
//                     return null;
//                   },
//                 ),
//
//                 // Newsletter subscription checkbox
//                 Padding(
//                   padding: const EdgeInsets.only(top: 16.0),
//                   child: Row(
//                     children: [
//                       SizedBox(
//                         height: 24,
//                         width: 24,
//                         child: Checkbox(
//                           value: _subscribeToNewsletter,
//                           onChanged: (value) {
//                             setState(() {
//                               _subscribeToNewsletter = value ?? false;
//                             });
//                           },
//                           activeColor: Theme.of(context).colorScheme.secondary,
//                           checkColor: Theme.of(context).colorScheme.surface,
//                           side: BorderSide(
//                             color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Text(
//                           "Subscribe to our newsletter for exclusive offers and updates",
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Theme.of(context).colorScheme.onSurface,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Error message
//                 if (_errorMessage != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Text(
//                       _errorMessage!,
//                       style: TextStyle(
//                         color: Theme.of(context).colorScheme.primary,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ),
//
//                 const SizedBox(height: 25),
//
//                 _isLoading
//                     ? CircularProgressIndicator()
//                     : MyButton(
//                   onTap: register,
//                   text: "Register",
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Already have an account?",
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Theme.of(context).colorScheme.onSurface,
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: widget.onLoginInstead,
//                       child: Text(
//                         "Login here",
//                         style: TextStyle(
//                           color: Theme.of(context).colorScheme.onSurface,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
