-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 29, 2026 at 10:21 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hospital_system`
--

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `clinic_id` int(11) NOT NULL,
  `doctor_id` int(11) DEFAULT NULL,
  `schedule_id` int(11) DEFAULT NULL,
  `schedule_override_id` int(11) DEFAULT NULL,
  `shift_id` int(11) NOT NULL,
  `booking_date` date NOT NULL,
  `queue_number` int(11) DEFAULT NULL,
  `status` enum('Waiting','Serving','Completed','Cancelled','NoShow') DEFAULT 'Waiting',
  `notes` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `called_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`id`, `patient_id`, `clinic_id`, `doctor_id`, `schedule_id`, `schedule_override_id`, `shift_id`, `booking_date`, `queue_number`, `status`, `notes`, `created_at`, `called_at`, `completed_at`) VALUES
(1, 1, 1, 3, 11, NULL, 1, '2026-09-24', 1, 'Completed', NULL, '2026-09-23 22:52:56', '2026-09-24 03:04:51', '2026-09-24 03:32:30'),
(2, 1, 1, 3, 3, NULL, 1, '2026-09-27', 1, 'Completed', NULL, '2026-09-27 10:13:50', '2026-09-27 13:43:04', '2026-09-27 13:47:14'),
(3, 1, 1, 1, 5, NULL, 1, '2026-09-28', 1, 'Completed', NULL, '2026-09-28 01:31:04', '2026-09-28 15:50:47', '2026-09-28 16:20:25'),
(4, 2, 1, 1, 5, NULL, 1, '2026-09-28', NULL, 'Cancelled', NULL, '2026-09-28 08:33:57', NULL, NULL),
(5, 3, 1, 1, 5, NULL, 1, '2026-09-28', 3, 'Waiting', NULL, '2026-09-28 08:49:51', NULL, NULL),
(6, 3, 1, 1, 5, NULL, 1, '2026-09-28', 2, 'Waiting', NULL, '2026-09-28 09:05:39', NULL, NULL),
(7, 1, 7, 20, 48, NULL, 2, '2026-09-28', 1, 'Waiting', NULL, '2026-09-28 11:25:14', NULL, NULL),
(8, 1, 7, 20, 48, NULL, 2, '2026-09-28', 2, 'Waiting', NULL, '2026-09-28 11:49:20', NULL, NULL),
(9, 1, 7, 20, 48, NULL, 2, '2026-09-28', 3, 'Waiting', NULL, '2026-09-28 11:57:30', NULL, NULL),
(10, 1, 3, 9, 24, NULL, 2, '2026-09-28', 1, 'Waiting', NULL, '2026-09-28 12:37:29', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `clinics`
--

CREATE TABLE `clinics` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `consultation_fee` decimal(10,2) NOT NULL DEFAULT 30.00,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinics`
--

INSERT INTO `clinics` (`id`, `name`, `description`, `consultation_fee`, `is_active`, `created_at`) VALUES
(1, 'الأسنان', 'عيادة الأسنان', 30.00, 1, '2026-09-23 20:29:42'),
(2, 'الجراحة العامة', 'عيادة الجراحة العامة', 30.00, 1, '2026-09-23 20:29:42'),
(3, 'الباطنة', 'عيادة الباطنة', 30.00, 1, '2026-09-23 20:29:42'),
(4, 'المخ والأعصاب', 'عيادة المخ والأعصاب', 30.00, 1, '2026-09-23 20:29:42'),
(5, 'المسالك البولية', 'عيادة المسالك البولية', 30.00, 1, '2026-09-23 20:29:42'),
(6, 'الجهاز الهضمي', 'عيادة الجهاز الهضمي', 30.00, 1, '2026-09-23 20:29:42'),
(7, 'العظام', 'عيادة العظام', 30.00, 1, '2026-09-23 20:29:42'),
(8, 'العظام والأعصاب الطرفية', 'عيادة العظام والأعصاب الطرفية', 30.00, 1, '2026-09-23 20:29:42'),
(9, 'أنف وأذن وحنجرة', 'عيادة الأنف والأذن والحنجرة', 30.00, 1, '2026-09-23 20:29:42'),
(10, 'السكري والغدد', 'عيادة السكري والغدد', 30.00, 1, '2026-09-23 20:29:42'),
(11, 'الجلدية', 'عيادة الجلدية', 30.00, 1, '2026-09-23 20:29:42'),
(12, 'جراحة الشرج والمستقيم', 'عيادة جراحة الشرج والمستقيم', 30.00, 1, '2026-09-23 20:29:42'),
(13, 'العيون', 'عيادة العيون', 30.00, 1, '2026-09-23 20:29:42'),
(14, 'جراحة الأطفال', 'عيادة جراحة الأطفال', 30.00, 1, '2026-09-23 20:29:42'),
(15, 'النساء والحوامل', 'عيادة النساء والحوامل', 30.00, 1, '2026-09-23 20:29:42'),
(16, 'التجميل والليزر', 'عيادة التجميل والليزر', 30.00, 1, '2026-09-23 20:29:42');

-- --------------------------------------------------------

--
-- Table structure for table `doctors`
--

CREATE TABLE `doctors` (
  `id` int(11) NOT NULL,
  `full_name` varchar(200) NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctors`
--

INSERT INTO `doctors` (`id`, `full_name`, `is_active`, `created_at`) VALUES
(1, 'د. شادي الحداد', 1, '2026-09-23 20:29:42'),
(2, 'د. عاطف أبو حطب', 1, '2026-09-23 20:29:42'),
(3, 'د. نور قويدر', 1, '2026-09-23 20:29:42'),
(4, 'د. زكريا سلمي', 1, '2026-09-23 20:29:42'),
(5, 'د. أيمن سعد', 1, '2026-09-23 20:29:42'),
(6, 'د. ناصر أبو شعبان', 1, '2026-09-23 20:29:42'),
(7, 'د. مروان أبو سعدة', 1, '2026-09-23 20:29:42'),
(8, 'د. حازم الحداد', 1, '2026-09-23 20:29:42'),
(9, 'د. حسن خلف', 1, '2026-09-23 20:29:42'),
(10, 'د. حسن العطار', 1, '2026-09-23 20:29:42'),
(11, 'د. محمد أبو حصيرة', 1, '2026-09-23 20:29:42'),
(12, 'د. حازم كحيل', 1, '2026-09-23 20:29:42'),
(13, 'د. أيمن عاشور', 1, '2026-09-23 20:29:42'),
(14, 'د. عادل الحكيم', 1, '2026-09-23 20:29:42'),
(15, 'د. عاطف الكحلوت', 1, '2026-09-23 20:29:42'),
(16, 'د. عماد أبو ناموس', 1, '2026-09-23 20:29:42'),
(17, 'د. علاء أبو وردة', 1, '2026-09-23 20:29:42'),
(18, 'د. محمد لبد', 1, '2026-09-23 20:29:42'),
(19, 'د. هاني بسيسو', 1, '2026-09-23 20:29:42'),
(20, 'د. فيصل صيام', 1, '2026-09-23 20:29:42'),
(21, 'د. محمد الرئيسي', 1, '2026-09-23 20:29:42'),
(22, 'د. هيثم دبابش', 1, '2026-09-23 20:29:42'),
(23, 'د. عيسى مسلم', 1, '2026-09-23 20:29:42'),
(24, 'د. تيسير الإسي', 1, '2026-09-23 20:29:42'),
(25, 'د. إبراهيم طافش', 1, '2026-09-23 20:29:42'),
(26, 'د. نائل زمو', 1, '2026-09-23 20:29:42'),
(27, 'د. سلامة التتر', 1, '2026-09-23 20:29:42'),
(28, 'د. رائد أبو سرية', 1, '2026-09-23 20:29:42'),
(29, 'د. موسى عياد', 1, '2026-09-23 20:29:42'),
(30, 'د. إيهاب أبو حمدة', 1, '2026-09-23 20:29:42'),
(31, 'د. عوض حسان', 1, '2026-09-23 20:29:42'),
(32, 'د. عبد الله الكاشف', 1, '2026-09-23 20:29:42'),
(33, 'د. ياسر الشريف', 1, '2026-09-23 20:29:42'),
(34, 'د. محمود الحلبي', 1, '2026-09-23 20:29:42'),
(35, 'د. يوسف ياسين', 1, '2026-09-23 20:29:42'),
(36, 'د. إسماعيل قاسم', 1, '2026-09-23 20:29:42'),
(37, 'د. صابرين ديب', 1, '2026-09-23 20:29:42'),
(38, 'د. إبراهيم البساينة', 1, '2026-09-23 20:29:42');

-- --------------------------------------------------------

--
-- Table structure for table `doctor_clinics`
--

CREATE TABLE `doctor_clinics` (
  `id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `clinic_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctor_clinics`
--

INSERT INTO `doctor_clinics` (`id`, `doctor_id`, `clinic_id`, `created_at`) VALUES
(1, 1, 1, '2026-09-23 20:29:42'),
(2, 2, 1, '2026-09-23 20:29:42'),
(3, 3, 1, '2026-09-23 20:29:42'),
(4, 4, 1, '2026-09-23 20:29:42'),
(5, 5, 2, '2026-09-23 20:29:42'),
(6, 6, 2, '2026-09-23 20:29:42'),
(7, 7, 2, '2026-09-23 20:29:42'),
(8, 8, 2, '2026-09-23 20:29:42'),
(9, 9, 3, '2026-09-23 20:29:42'),
(10, 10, 3, '2026-09-23 20:29:42'),
(11, 11, 3, '2026-09-23 20:29:42'),
(12, 12, 4, '2026-09-23 20:29:42'),
(13, 13, 4, '2026-09-23 20:29:42'),
(14, 14, 5, '2026-09-23 20:29:42'),
(15, 15, 5, '2026-09-23 20:29:42'),
(16, 16, 5, '2026-09-23 20:29:42'),
(17, 17, 6, '2026-09-23 20:29:42'),
(18, 18, 7, '2026-09-23 20:29:42'),
(19, 19, 7, '2026-09-23 20:29:42'),
(20, 20, 7, '2026-09-23 20:29:42'),
(21, 21, 8, '2026-09-23 20:29:42'),
(22, 22, 9, '2026-09-23 20:29:42'),
(23, 23, 9, '2026-09-23 20:29:42'),
(24, 24, 9, '2026-09-23 20:29:42'),
(25, 25, 9, '2026-09-23 20:29:42'),
(26, 26, 9, '2026-09-23 20:29:42'),
(27, 27, 10, '2026-09-23 20:29:42'),
(28, 28, 11, '2026-09-23 20:29:42'),
(29, 29, 11, '2026-09-23 20:29:42'),
(30, 30, 11, '2026-09-23 20:29:42'),
(31, 31, 12, '2026-09-23 20:29:42'),
(32, 32, 13, '2026-09-23 20:29:42'),
(33, 33, 13, '2026-09-23 20:29:42'),
(34, 34, 13, '2026-09-23 20:29:42'),
(35, 35, 13, '2026-09-23 20:29:42'),
(36, 36, 15, '2026-09-23 20:29:42'),
(37, 37, 15, '2026-09-23 20:29:42'),
(38, 38, 15, '2026-09-23 20:29:42'),
(39, 28, 16, '2026-09-23 20:29:42');

-- --------------------------------------------------------

--
-- Table structure for table `hospital_info`
--

CREATE TABLE `hospital_info` (
  `id` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `department` varchar(200) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hospital_info`
--

INSERT INTO `hospital_info` (`id`, `name`, `department`, `address`, `phone`, `created_at`) VALUES
(1, 'مستشفى أصدقاء المريض الخيري', 'قسم العلاقات العامة والإعلام', 'غزة - الرمال - شارع الشهداء', '0595188009', '2026-09-23 20:29:41');

-- --------------------------------------------------------

--
-- Table structure for table `invoices`
--

CREATE TABLE `invoices` (
  `id` int(11) NOT NULL,
  `invoice_number` varchar(50) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `booking_id` int(11) DEFAULT NULL,
  `invoice_type` enum('Laboratory','Radiology','Pharmacy','Clinic') NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `status` enum('Pending','Paid','Rejected','Cancelled') DEFAULT 'Pending',
  `fulfillment_status` enum('Pending','Completed') DEFAULT 'Pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `paid_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `invoices`
--

INSERT INTO `invoices` (`id`, `invoice_number`, `patient_id`, `booking_id`, `invoice_type`, `description`, `amount`, `status`, `fulfillment_status`, `created_at`, `paid_at`) VALUES
(1, 'INV-0001', 1, NULL, 'Laboratory', 'تحليل دم', 30.00, 'Paid', 'Completed', '2026-09-23 20:29:43', '2026-09-28 14:29:20'),
(2, 'INV-0002', 1, NULL, 'Radiology', 'صورة أشعة', 50.00, 'Paid', 'Completed', '2026-09-23 20:29:43', '2026-09-28 14:28:23'),
(3, 'INV-0003', 1, NULL, 'Pharmacy', 'فاتورة صيدلية', 25.00, 'Paid', 'Completed', '2026-09-23 20:29:43', '2026-09-28 14:26:55'),
(4, 'INV-0004', 2, NULL, 'Laboratory', 'تحليل دم', 30.00, 'Pending', 'Pending', '2026-09-23 20:29:43', NULL),
(11, 'INV-20260924062016537', 1, NULL, 'Pharmacy', 'Panadol 30\n Pain reliever 20 ', 50.00, 'Paid', 'Pending', '2026-09-24 10:20:16', '2026-09-28 14:30:29'),
(13, 'INV-TEST-1790500151', 1, NULL, 'Pharmacy', 'Test payment for Reject', 50.00, 'Paid', 'Pending', '2026-09-27 09:09:11', '2026-09-28 14:26:24'),
(14, 'INV-TEST-1790500609', 1, NULL, 'Pharmacy', 'Test payment for Reject', 50.00, 'Paid', 'Completed', '2026-09-27 09:16:49', '2026-09-27 12:17:39'),
(15, 'INV-20260927213104510', 1, 3, 'Clinic', 'حجز عيادة الأسنان - د. شادي الحداد', 30.00, 'Paid', 'Pending', '2026-09-28 01:31:04', '2026-09-28 11:21:44'),
(16, 'INV-20260928043357757', 2, 4, 'Clinic', 'حجز عيادة الأسنان - د. شادي الحداد', 30.00, 'Pending', 'Pending', '2026-09-28 08:33:58', NULL),
(17, 'INV-20260928044951814', 3, 5, 'Clinic', 'حجز عيادة الأسنان - د. شادي الحداد', 30.00, 'Paid', 'Pending', '2026-09-28 08:49:51', '2026-09-28 15:22:09'),
(18, 'INV-20260928050539633', 3, 6, 'Clinic', 'حجز عيادة الأسنان - د. شادي الحداد', 30.00, 'Paid', 'Pending', '2026-09-28 09:05:39', '2026-09-28 12:12:07'),
(19, 'INV-20260928072514305', 1, 7, 'Clinic', 'حجز عيادة العظام - د. فيصل صيام', 30.00, 'Paid', 'Pending', '2026-09-28 11:25:14', '2026-09-28 14:25:56'),
(20, 'INV-20260928074920319', 1, 8, 'Clinic', 'حجز عيادة العظام - د. فيصل صيام', 30.00, 'Paid', 'Pending', '2026-09-28 11:49:20', '2026-09-28 14:51:18'),
(21, 'INV-20260928075730669', 1, 9, 'Clinic', 'حجز عيادة العظام - د. فيصل صيام', 30.00, 'Paid', 'Pending', '2026-09-28 11:57:30', '2026-09-28 14:59:06'),
(22, 'INV-20260928083729668', 1, 10, 'Clinic', 'حجز عيادة الباطنة - د. حسن خلف', 30.00, 'Paid', 'Pending', '2026-09-28 12:37:29', '2026-09-28 15:38:34'),
(23, 'INV-20260928091828182', 1, NULL, 'Laboratory', 'تحليل CBC', 20.00, 'Paid', 'Completed', '2026-09-28 13:18:28', '2026-09-28 16:19:42'),
(24, 'INV-20260928093151211', 1, NULL, 'Radiology', 'أشعة أسنان', 50.00, 'Paid', 'Completed', '2026-09-28 13:31:51', '2026-09-28 16:33:24'),
(25, 'INV-20260928093431504', 1, NULL, 'Radiology', 'أشعة أسنان', 70.00, 'Paid', 'Completed', '2026-09-28 13:34:31', '2026-09-28 16:35:20'),
(26, 'INV-20260928093551614', 1, NULL, 'Laboratory', 'تحليل بول', 15.00, 'Paid', 'Completed', '2026-09-28 13:35:51', '2026-09-28 16:36:20'),
(27, 'INV-20260928093733093', 1, NULL, 'Laboratory', 'تحليل CBC', 10000.00, 'Paid', 'Completed', '2026-09-28 13:37:33', '2026-09-28 16:39:54');

-- --------------------------------------------------------

--
-- Table structure for table `patients`
--

CREATE TABLE `patients` (
  `id` int(11) NOT NULL,
  `national_id` char(9) NOT NULL,
  `full_name` varchar(200) NOT NULL,
  `date_of_birth` date DEFAULT NULL,
  `nationality` varchar(100) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `patients`
--

INSERT INTO `patients` (`id`, `national_id`, `full_name`, `date_of_birth`, `nationality`, `phone`, `created_at`, `updated_at`) VALUES
(1, '123456789', 'أحمد محمد أحمد', '1990-05-12', 'فلسطيني', '0590000001', '2026-09-23 20:29:43', '2026-09-23 21:09:49'),
(2, '987654321', 'سارة خالد علي', '1995-08-20', 'فلسطينية', '0590000002', '2026-09-23 20:29:43', '2026-09-23 21:10:13'),
(3, '012345678', 'محمد سامر حسن', '1988-03-15', 'فلسطيني', '0590000003', '2026-09-23 20:29:43', '2026-09-23 21:10:44');

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` int(11) NOT NULL,
  `invoice_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `sender_name` varchar(150) DEFAULT NULL,
  `sender_phone` varchar(30) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `receipt_url` varchar(500) DEFAULT NULL,
  `status` enum('Pending','Approved','Rejected') DEFAULT 'Pending',
  `telegram_message_id` varchar(100) DEFAULT NULL,
  `reviewed_by` varchar(100) DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  `rejection_reason` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `invoice_id`, `patient_id`, `sender_name`, `sender_phone`, `amount`, `receipt_url`, `status`, `telegram_message_id`, `reviewed_by`, `reviewed_at`, `rejection_reason`, `created_at`) VALUES
(8, 13, 1, 'محمد أحمد', '591234567', 50.00, 'C:/n8n-data/receipts/payment_13_20260927051343630.jpg', 'Rejected', NULL, NULL, '2026-09-27 12:14:01', NULL, '2026-09-27 09:13:43'),
(9, 14, 1, 'محمد أحمد', '591234567', 50.00, 'C:/n8n-data/receipts/payment_14_20260927051721203.jpg', 'Approved', NULL, NULL, '2026-09-27 12:17:39', NULL, '2026-09-27 09:17:21'),
(10, 15, 1, 'Test User', '590000000', 30.00, 'C:/n8n-data/receipts/payment_15_20260928042031516.jpg', 'Approved', NULL, NULL, '2026-09-28 11:21:44', NULL, '2026-09-28 08:20:31'),
(11, 16, 2, 'Test User', '590000000', 30.00, 'C:/n8n-data/receipts/payment_16_20260928044537330.jpg', 'Rejected', NULL, NULL, '2026-09-28 11:46:04', NULL, '2026-09-28 08:45:37'),
(12, 18, 3, 'محمد سامر حسن', '599999999', 30.00, 'C:/n8n-data/receipts/payment_18_20260928050749298.jpg', 'Approved', NULL, NULL, '2026-09-28 12:12:07', NULL, '2026-09-28 09:07:49'),
(13, 19, 1, 'أحمد محمد أحمد', '591234567', 30.00, 'C:/n8n-data/receipts/payment_19_20260928072543255.jpg', 'Approved', NULL, NULL, '2026-09-28 14:25:56', NULL, '2026-09-28 11:25:43'),
(14, 13, 1, 'أحمد محمد أحمد', '591234567', 50.00, 'C:/n8n-data/receipts/payment_13_20260928072623314.jpg', 'Approved', NULL, NULL, '2026-09-28 14:26:24', NULL, '2026-09-28 11:26:23'),
(15, 3, 1, 'أحمد محمد أحمد', '591234567', 25.00, 'C:/n8n-data/receipts/payment_3_20260928072647568.jpg', 'Approved', NULL, NULL, '2026-09-28 14:26:55', NULL, '2026-09-28 11:26:47'),
(17, 2, 1, 'أحمد محمد أحمد', '23155', 50.00, 'C:/n8n-data/receipts/payment_2_20260928072814585.png', 'Approved', NULL, NULL, '2026-09-28 14:28:23', NULL, '2026-09-28 11:28:14'),
(18, 1, 1, 'أحمد محمد أحمد', '5645', 30.00, 'C:/n8n-data/receipts/payment_1_20260928072918388.jpg', 'Approved', NULL, NULL, '2026-09-28 14:29:20', NULL, '2026-09-28 11:29:18'),
(19, 11, 1, 'أحمد محمد أحمد', '599999999', 50.00, 'C:/n8n-data/receipts/payment_11_20260928073027212.jpg', 'Approved', NULL, NULL, '2026-09-28 14:30:29', NULL, '2026-09-28 11:30:27'),
(20, 20, 1, 'عبد الكريم', '599999999', 30.00, 'C:/n8n-data/receipts/payment_20_20260928075006715.jpg', 'Approved', NULL, NULL, '2026-09-28 14:51:18', NULL, '2026-09-28 11:50:06'),
(21, 21, 1, 'ممدوح', '599999999', 30.00, 'C:/n8n-data/receipts/payment_21_20260928075811133.jpg', 'Approved', NULL, NULL, '2026-09-28 14:59:06', NULL, '2026-09-28 11:58:11'),
(22, 17, 3, 'محمد سامر حسن', '599999999', 30.00, 'C:/n8n-data/receipts/payment_17_20260928082200803.jpg', 'Approved', NULL, NULL, '2026-09-28 15:22:09', NULL, '2026-09-28 12:22:00'),
(23, 22, 1, 'أحمد محمد أحمد', '599999999', 30.00, 'C:/n8n-data/receipts/payment_22_20260928083743094.jpg', 'Approved', NULL, NULL, '2026-09-28 15:38:34', NULL, '2026-09-28 12:37:43'),
(24, 23, 1, 'أحمد محمد أحمد', '599999999', 20.00, 'C:/n8n-data/receipts/payment_23_20260928091927802.jpg', 'Approved', NULL, NULL, '2026-09-28 16:19:42', NULL, '2026-09-28 13:19:27'),
(25, 24, 1, 'أحمد محمد أحمد', '599999999', 50.00, 'C:/n8n-data/receipts/payment_24_20260928093258144.jpg', 'Approved', NULL, NULL, '2026-09-28 16:33:24', NULL, '2026-09-28 13:32:58'),
(26, 25, 1, 'أحمد محمد أحمد', '599999999', 70.00, 'C:/n8n-data/receipts/payment_25_20260928093503012.jpg', 'Approved', NULL, NULL, '2026-09-28 16:35:20', NULL, '2026-09-28 13:35:03'),
(27, 26, 1, 'أحمد محمد أحمد', '599999999', 15.00, 'C:/n8n-data/receipts/payment_26_20260928093610580.jpg', 'Approved', NULL, NULL, '2026-09-28 16:36:20', NULL, '2026-09-28 13:36:10'),
(28, 27, 1, 'أحمد محمد أحمد', '599999999', 10000.00, 'C:/n8n-data/receipts/payment_27_20260928093803225.jpg', 'Rejected', NULL, NULL, '2026-09-28 16:38:22', NULL, '2026-09-28 13:38:03'),
(29, 27, 1, 'أحمد محمد أحمد', '599999999', 10000.00, 'C:/n8n-data/receipts/payment_27_20260928093857339.png', 'Rejected', NULL, NULL, '2026-09-28 16:39:05', NULL, '2026-09-28 13:38:57'),
(30, 27, 1, 'أحمد محمد أحمد', '599999999', 10000.00, 'C:/n8n-data/receipts/payment_27_20260928093950906.jpg', 'Approved', NULL, NULL, '2026-09-28 16:39:54', NULL, '2026-09-28 13:39:50');

-- --------------------------------------------------------

--
-- Table structure for table `schedules`
--

CREATE TABLE `schedules` (
  `id` int(11) NOT NULL,
  `clinic_id` int(11) NOT NULL,
  `doctor_id` int(11) DEFAULT NULL,
  `shift_id` int(11) NOT NULL,
  `day_of_week` enum('Saturday','Sunday','Monday','Tuesday','Wednesday','Thursday','Friday') NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `notes` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `schedules`
--

INSERT INTO `schedules` (`id`, `clinic_id`, `doctor_id`, `shift_id`, `day_of_week`, `is_active`, `notes`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, 'Saturday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(2, 1, 2, 2, 'Saturday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(3, 1, 3, 1, 'Sunday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(4, 1, 4, 2, 'Sunday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(5, 1, 1, 1, 'Monday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(6, 1, 2, 2, 'Monday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(7, 1, 3, 1, 'Tuesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(8, 1, 4, 2, 'Tuesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(9, 1, 1, 1, 'Wednesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(10, 1, 2, 2, 'Wednesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(11, 1, 3, 1, 'Thursday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(12, 1, 4, 2, 'Thursday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(13, 2, 5, 1, 'Saturday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(14, 2, 6, 2, 'Saturday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(15, 2, 7, 1, 'Sunday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(16, 2, 8, 1, 'Tuesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(17, 2, 5, 1, 'Wednesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(18, 2, 6, 1, 'Thursday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(19, 2, 7, 2, 'Thursday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(20, 3, 9, 1, 'Saturday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(21, 3, 10, 2, 'Saturday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(22, 3, 9, 1, 'Sunday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(23, 3, 11, 1, 'Monday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(24, 3, 9, 2, 'Monday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(25, 3, 11, 1, 'Wednesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(26, 3, 9, 2, 'Wednesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(27, 3, 11, 1, 'Thursday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(28, 4, 12, 1, 'Saturday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(29, 4, 13, 1, 'Sunday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(30, 4, 13, 1, 'Tuesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(31, 4, 12, 1, 'Wednesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(32, 5, 14, 1, 'Saturday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(33, 5, 15, 2, 'Saturday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(34, 5, 16, 1, 'Sunday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(35, 5, 14, 1, 'Monday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(36, 5, 15, 2, 'Monday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(37, 5, 14, 1, 'Wednesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(38, 5, 15, 2, 'Wednesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(39, 5, 14, 1, 'Thursday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(40, 5, 15, 2, 'Thursday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(41, 5, 14, 1, 'Tuesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(42, 5, 16, 2, 'Tuesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(43, 6, 17, 2, 'Thursday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(44, 7, 18, 1, 'Saturday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(45, 7, 19, 2, 'Saturday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(46, 7, 18, 1, 'Sunday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(47, 7, 18, 1, 'Monday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(48, 7, 20, 2, 'Monday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(49, 7, 18, 1, 'Wednesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(50, 7, 19, 2, 'Wednesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(51, 7, 18, 1, 'Thursday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(52, 8, 21, 1, 'Sunday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(53, 8, 21, 1, 'Tuesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(54, 8, 21, 1, 'Thursday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(55, 9, 22, 1, 'Saturday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(56, 9, 23, 2, 'Saturday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(57, 9, 24, 1, 'Sunday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(58, 9, 25, 2, 'Sunday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(59, 9, 22, 1, 'Monday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(60, 9, 23, 2, 'Monday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(61, 9, 26, 1, 'Tuesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(62, 9, 25, 2, 'Tuesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(63, 9, 24, 1, 'Wednesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(64, 9, 23, 2, 'Wednesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(65, 9, 26, 1, 'Thursday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(66, 9, 25, 2, 'Thursday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(67, 10, 27, 1, 'Monday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(68, 11, 28, 1, 'Saturday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(69, 11, 29, 1, 'Sunday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(70, 11, 30, 1, 'Monday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(71, 11, 29, 1, 'Tuesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(72, 11, 28, 1, 'Wednesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(73, 11, 30, 1, 'Thursday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(74, 12, 31, 1, 'Wednesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(75, 13, 32, 1, 'Saturday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(76, 13, 33, 2, 'Saturday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(77, 13, 34, 1, 'Sunday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(78, 13, 32, 2, 'Sunday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(79, 13, 33, 1, 'Monday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(80, 13, 32, 2, 'Monday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(81, 13, 34, 1, 'Tuesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(82, 13, 35, 2, 'Tuesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(83, 13, 35, 1, 'Wednesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(84, 13, 32, 2, 'Wednesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(85, 13, 35, 1, 'Thursday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(86, 13, 32, 2, 'Thursday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(87, 14, NULL, 1, 'Saturday', 1, 'يتواجد نخبة من الأطباء - يحددهم المشرف', '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(88, 14, NULL, 1, 'Wednesday', 1, 'يتواجد نخبة من الأطباء - يحددهم المشرف', '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(89, 15, 36, 1, 'Saturday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(90, 15, 36, 1, 'Tuesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(91, 15, 37, 1, 'Sunday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(92, 15, 37, 1, 'Thursday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(93, 15, 38, 1, 'Monday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(94, 15, 38, 1, 'Wednesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(95, 16, 28, 1, 'Saturday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(96, 16, 28, 1, 'Sunday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(97, 16, 28, 1, 'Tuesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42'),
(98, 16, 28, 1, 'Wednesday', 1, NULL, '2026-09-23 20:29:42', '2026-09-23 20:29:42');

-- --------------------------------------------------------

--
-- Table structure for table `schedule_overrides`
--

CREATE TABLE `schedule_overrides` (
  `id` int(11) NOT NULL,
  `override_date` date NOT NULL,
  `clinic_id` int(11) NOT NULL,
  `shift_id` int(11) NOT NULL,
  `original_doctor_id` int(11) DEFAULT NULL,
  `replacement_doctor_id` int(11) DEFAULT NULL,
  `override_start_time` time DEFAULT NULL,
  `override_end_time` time DEFAULT NULL,
  `is_closed` tinyint(1) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `reason` varchar(255) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `shifts`
--

CREATE TABLE `shifts` (
  `id` int(11) NOT NULL,
  `name` enum('Morning','Evening') NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `shifts`
--

INSERT INTO `shifts` (`id`, `name`, `start_time`, `end_time`, `is_active`, `created_at`) VALUES
(1, 'Morning', '08:00:00', '14:00:00', 1, '2026-09-23 20:29:42'),
(2, 'Evening', '14:00:00', '19:00:00', 1, '2026-09-23 20:29:42');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_queue_number` (`booking_date`,`doctor_id`,`shift_id`,`queue_number`),
  ADD KEY `idx_patient_bookings` (`patient_id`,`booking_date`),
  ADD KEY `idx_doctor_queue` (`doctor_id`,`booking_date`,`shift_id`,`queue_number`),
  ADD KEY `fk_booking_clinic` (`clinic_id`),
  ADD KEY `fk_booking_schedule` (`schedule_id`),
  ADD KEY `fk_booking_override` (`schedule_override_id`),
  ADD KEY `fk_booking_shift` (`shift_id`);

--
-- Indexes for table `clinics`
--
ALTER TABLE `clinics`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `doctors`
--
ALTER TABLE `doctors`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `full_name` (`full_name`);

--
-- Indexes for table `doctor_clinics`
--
ALTER TABLE `doctor_clinics`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_doctor_clinic` (`doctor_id`,`clinic_id`),
  ADD KEY `fk_dc_clinic` (`clinic_id`);

--
-- Indexes for table `hospital_info`
--
ALTER TABLE `hospital_info`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `invoice_number` (`invoice_number`),
  ADD KEY `idx_patient_invoices` (`patient_id`,`status`),
  ADD KEY `fk_invoice_booking` (`booking_id`);

--
-- Indexes for table `patients`
--
ALTER TABLE `patients`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `national_id` (`national_id`),
  ADD UNIQUE KEY `national_id_2` (`national_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_payment_invoice` (`invoice_id`,`status`),
  ADD KEY `idx_payment_patient` (`patient_id`,`status`);

--
-- Indexes for table `schedules`
--
ALTER TABLE `schedules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_schedule_doctor` (`doctor_id`),
  ADD KEY `fk_schedule_shift` (`shift_id`),
  ADD KEY `idx_schedule_lookup` (`clinic_id`,`day_of_week`,`shift_id`,`is_active`);

--
-- Indexes for table `schedule_overrides`
--
ALTER TABLE `schedule_overrides`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_override` (`override_date`,`clinic_id`,`shift_id`),
  ADD KEY `fk_override_clinic` (`clinic_id`),
  ADD KEY `fk_override_shift` (`shift_id`),
  ADD KEY `fk_override_original_doctor` (`original_doctor_id`),
  ADD KEY `fk_override_replacement_doctor` (`replacement_doctor_id`);

--
-- Indexes for table `shifts`
--
ALTER TABLE `shifts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `clinics`
--
ALTER TABLE `clinics`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `doctors`
--
ALTER TABLE `doctors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `doctor_clinics`
--
ALTER TABLE `doctor_clinics`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `hospital_info`
--
ALTER TABLE `hospital_info`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `invoices`
--
ALTER TABLE `invoices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `patients`
--
ALTER TABLE `patients`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `schedules`
--
ALTER TABLE `schedules`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=99;

--
-- AUTO_INCREMENT for table `schedule_overrides`
--
ALTER TABLE `schedule_overrides`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shifts`
--
ALTER TABLE `shifts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `fk_booking_clinic` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_booking_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_booking_override` FOREIGN KEY (`schedule_override_id`) REFERENCES `schedule_overrides` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_booking_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_booking_schedule` FOREIGN KEY (`schedule_id`) REFERENCES `schedules` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_booking_shift` FOREIGN KEY (`shift_id`) REFERENCES `shifts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `doctor_clinics`
--
ALTER TABLE `doctor_clinics`
  ADD CONSTRAINT `fk_dc_clinic` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_dc_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `invoices`
--
ALTER TABLE `invoices`
  ADD CONSTRAINT `fk_invoice_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_invoice_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `fk_payment_invoice` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_payment_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `schedules`
--
ALTER TABLE `schedules`
  ADD CONSTRAINT `fk_schedule_clinic` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_schedule_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_schedule_shift` FOREIGN KEY (`shift_id`) REFERENCES `shifts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `schedule_overrides`
--
ALTER TABLE `schedule_overrides`
  ADD CONSTRAINT `fk_override_clinic` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_override_original_doctor` FOREIGN KEY (`original_doctor_id`) REFERENCES `doctors` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_override_replacement_doctor` FOREIGN KEY (`replacement_doctor_id`) REFERENCES `doctors` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_override_shift` FOREIGN KEY (`shift_id`) REFERENCES `shifts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
