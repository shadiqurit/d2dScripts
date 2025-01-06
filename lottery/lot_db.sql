-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 01, 2025 at 02:40 PM
-- Server version: 8.0.39-cll-lve
-- PHP Version: 8.3.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+12:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */
/*!40101 SET NAMES utf8mb4 */

--
-- Database: `sadiqpro_lot`
--

-- --------------------------------------------------------

--
-- Table structure for table `lottery_names`
--

CREATE TABLE `lottery_names` (
  `id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `status` tinyint(1) DEFAULT '0',
  `win_date` datetime DEFAULT NULL,
  `bank` varchar(255) NOT NULL,
  `branch_name` varchar(255) NOT NULL,
  `account_number` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `lottery_names`
--

INSERT INTO `lottery_names` (`id`, `name`, `status`, `win_date`, `bank`, `branch_name`, `account_number`) VALUES
(1, 'Md. Khalilur Rahman 1', 0, NULL, 'IBBLPLC', 'Dhanmondi Branch', '20502050204664905'),
(2, 'Md. Khalilur Rahman 2', 0, NULL, 'IBBLPLC', 'Dhanmondi Branch', '20502050204664905'),
(3, 'Md. Yasir Arafat 1', 0, NULL, 'IBBLPLC', 'Dhanmondi Branch', '20502050203785302'),
(4, 'Md. Yasir Arafat 2', 0, NULL, 'IBBLPLC', 'Dhanmondi Branch', '20502050203785302'),
(5, 'SK. MD. IMRAN', 0, NULL, 'IBBLPLC', 'Dhanmondi Branch', '20502050204949002'),
(6, 'Mohammad Luthfor Rahman', 0, NULL, 'IBBLPLC', 'Dhanmondi Branch', '20502050203451917'),
(7, 'MD Rashedul Arifin', 0, NULL, 'IBBLPLC', 'Dhanmondi Branch', '20502050203536902'),
(8, 'MD. SHADIQUR RAHMAN', 0, NULL, 'IBBLPLC', 'Dhanmondi Branch', '20502050204986704');

-- --------------------------------------------------------

--
-- Table structure for table `winners`
--

CREATE TABLE `winners` (
  `id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `win_date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `lottery_names`
--
ALTER TABLE `lottery_names`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `winners`
--
ALTER TABLE `winners`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `lottery_names`
--
ALTER TABLE `lottery_names`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `winners`
--
ALTER TABLE `winners`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;
COMMIT;
