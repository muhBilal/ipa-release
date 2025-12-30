import 'package:ngoerahsun/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

class OurFacilityView1 extends StatelessWidget {
  const OurFacilityView1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppColors.primary,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Our Facilities',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: const Color(0xFF2196F3),
                child: const SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 60),
                      Icon(
                        Icons.medical_services_rounded,
                        color: Colors.white,
                        size: 60,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'ngoerahsun Hospital',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Advanced Medical Facilities',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        const Text(
                          'Facilities',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2196F3),
                            letterSpacing: 2,
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          'Departments',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF64748B),
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 3,
                      width: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2196F3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildFacilityCard(
                      title: 'Emergency Department',
                      subtitle: '24/7 Emergency Care',
                      description: 'Fully equipped emergency department with modern trauma facilities, ICU beds, and specialized emergency medical team available round the clock.',
                      icon: Icons.local_hospital_rounded,
                      imagePath: 'assets/emergency.jpg',
                    ),
                    const SizedBox(height: 20),
                    _buildFacilityCard(
                      title: 'Surgical Suites',
                      subtitle: 'Advanced Operating Rooms',
                      description: 'State-of-the-art surgical facilities with 12 modern operating theaters equipped with latest surgical technology and monitoring systems.',
                      icon: Icons.cut_rounded,
                      imagePath: 'assets/surgery.jpg',
                    ),
                    const SizedBox(height: 20),
                    _buildFacilityCard(
                      title: 'Radiology Center',
                      subtitle: 'Diagnostic Imaging',
                      description: 'Complete imaging services including MRI, CT scan, X-ray, ultrasound, and mammography with digital imaging technology.',
                      icon: Icons.camera_alt_rounded,
                      imagePath: 'assets/radiology.jpg',
                    ),
                    const SizedBox(height: 20),
                    _buildFacilityCard(
                      title: 'Laboratory Services',
                      subtitle: 'Clinical & Pathology Lab',
                      description: 'Comprehensive laboratory services with automated analyzers for blood work, microbiology, pathology, and molecular diagnostics.',
                      icon: Icons.science_rounded,
                      imagePath: 'assets/laboratory.jpg',
                    ),
                    const SizedBox(height: 20),
                    _buildFacilityCard(
                      title: 'Intensive Care Unit',
                      subtitle: 'Critical Care',
                      description: 'Modern ICU with advanced life support systems, continuous monitoring, and specialized critical care nursing staff.',
                      icon: Icons.monitor_heart_rounded,
                      imagePath: 'assets/icu.jpg',
                    ),
                    const SizedBox(height: 20),
                    _buildFacilityCard(
                      title: 'Rehabilitation Center',
                      subtitle: 'Physical & Occupational Therapy',
                      description: 'Comprehensive rehabilitation services including physiotherapy, occupational therapy, and sports medicine facilities.',
                      icon: Icons.fitness_center_rounded,
                      imagePath: 'assets/rehab.jpg',
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2196F3),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2196F3).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Internationally Accredited',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'All our facilities meet international healthcare standards and are regularly audited for quality assurance',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityCard({
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required String imagePath,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade100,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.primary,
                    size: 60,
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      color: const Color(0xFF2196F3),
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2196F3),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}