/* *********************************************************
************************************************************
**          Constants used in Risk Reporting              **
************************************************************
********************************************************** */

EXPORT Constants := MODULE
	SHARED at := '@lexisnexisrisk.com,';
	
	EXPORT Debugger := 'Michele.Walklin' + at;
	
	SHARED ECL_Developers := 
										'David.Schlangen' + at +
										'Todd.Steil' + at +
										'Michele.Walklin' + at +
										'Kevin.Huls' + at +
										'Rick.Schultz' + at +
										// 'Frank.Allen' + at +
										'Andi.Koenen' + at +
										'';
		SHARED Product := 
										// 'Greg.Bethke' + at +
										'Michele.Walklin' + at +
										'';								
										
		SHARED IIDProduct := 
										'Cindy.Vaughn' + at +
										'';
										
		SHARED FPProduct := 
										// 'Kalie.Lee' + at +
										'Jeff.Butler' + at +
										'';
										
										
		SHARED RV5Product := 
										'Seth.Partain' + at +
										'Chad.Kimble' + at +

										'';
							
	SHARED QA := '';
				
	SHARED Modeling := 'Nicholas.Montpetit' + at +
							'Darrin.Udean' + at +
							'Heather.Mccarl' + at +
							'';
	
	EXPORT emailv2RiskViewReportsTo := ECL_Developers + Product;
	// EXPORT emailv2RiskViewReportsTo := Debugger;
	
	EXPORT emailRiskView2ReportsTo := ECL_Developers + RV5Product; 
	// EXPORT emailRiskView2ReportsTo := Debugger;
	
	EXPORT emailv2InstantIDReportsTo := ECL_Developers + IIDProduct; 
	// EXPORT emailv2InstantIDReportsTo := Debugger;
	
	EXPORT emailv2FraudPointReportsTo := ECL_Developers + FPProduct;
	// EXPORT emailv2FraudPointReportsTo := Debugger;
	
	// EXPORT emailAccountMonitoringReportsTo := ECL_Developers + Product + QA + Modeling;
	EXPORT emailAccountMonitoringReportsTo := Debugger;

	
	EXPORT emailSAOTHealthReportsTo := 
																		 'Todd.Steil' + at +
																		 'John.Freibaum' + at +
																		 'Valerie.Minnis' + at +
																			'';
	
	EXPORT month (UNSIGNED1 mnth) := CASE(mnth,
																				0 => 'December',
																				1 => 'January',
																				2 => 'February',
																				3 => 'March',
																				4 => 'April',
																				5 => 'May',
																				6 => 'June',
																				7 => 'July',
																				8 => 'August',
																				9 => 'September',
																				10 => 'October',
																				11 => 'November',
																				12 => 'December',
																				'Unknown');
	
	
	/* *******************************************************************************
   *  Thresholds - If this field changes more than the threshold specified below   *
   * it will be flagged in the email as a "potential problem".                     *
	 ******************************************************************************* */
	// Score Thresholds
	EXPORT ThreshPercent_Scored_100 := 0.250;
	EXPORT ThreshPercent_Scored_101 := 0.250;
	EXPORT ThreshPercent_Scored_102 := 0.250;
	EXPORT ThreshPercent_Scored_103 := 0.250;
	EXPORT ThreshPercent_Scored_104 := 0.250;
	EXPORT ThreshPercent_Scored_200 := 0.250;
	EXPORT ThreshPercent_Scored_201 := 0.250;
	EXPORT ThreshPercent_Scored_202 := 0.250;
	EXPORT ThreshPercent_Scored_203 := 0.250;
	EXPORT ThreshPercent_Scored_222 := 1.000;
	// Score Bucket Thresholds
	EXPORT ThreshRiskViewScoreBuckets := 6.500;
	EXPORT ThreshFraudPointScoreBuckets := 10.000;
	EXPORT ThreshScoredBelow100 := 0.010;
	EXPORT ThreshScoredAbove900 := 0.010;
	// CVI Thresholds
	EXPORT ThreshPercent_CVI_00 := 1.000;
	EXPORT ThreshPercent_CVI_10 := 2.000;
	EXPORT ThreshPercent_CVI_20 := 3.000;
	EXPORT ThreshPercent_CVI_30 := 1.000;
	EXPORT ThreshPercent_CVI_40 := 3.000;
	EXPORT ThreshPercent_CVI_50 := 4.500;
	// NAS Thresholds
	EXPORT ThreshPercent_NAS_0 := 1.000;
	EXPORT ThreshPercent_NAS_1 := 0.500;
	EXPORT ThreshPercent_NAS_2 := 2.000;
	EXPORT ThreshPercent_NAS_3 := 0.050;
	EXPORT ThreshPercent_NAS_4 := 0.100;
	EXPORT ThreshPercent_NAS_5 := 0.050;
	EXPORT ThreshPercent_NAS_6 := 0.050;
	EXPORT ThreshPercent_NAS_7 := 0.250;
	EXPORT ThreshPercent_NAS_8 := 3.000;
	EXPORT ThreshPercent_NAS_9 := 4.500;
	EXPORT ThreshPercent_NAS_10 := 0.250;
	EXPORT ThreshPercent_NAS_11 := 0.250;
	EXPORT ThreshPercent_NAS_12 := 4.000;
	// NAP Thresholds
	EXPORT ThreshPercent_NAP_0 := 6.500;
	EXPORT ThreshPercent_NAP_1 := 0.250;
	EXPORT ThreshPercent_NAP_2 := 0.050;
	EXPORT ThreshPercent_NAP_3 := 0.500;
	EXPORT ThreshPercent_NAP_4 := 0.500;
	EXPORT ThreshPercent_NAP_5 := 1.000;
	EXPORT ThreshPercent_NAP_6 := 0.500;
	EXPORT ThreshPercent_NAP_7 := 0.500;
	EXPORT ThreshPercent_NAP_8 := 2.000;
	EXPORT ThreshPercent_NAP_9 := 2.000;
	EXPORT ThreshPercent_NAP_10 := 0.500;
	EXPORT ThreshPercent_NAP_11 := 1.500;
	EXPORT ThreshPercent_NAP_12 := 2.000;
	// Alert Thresholds
	EXPORT ThreshPercent_Alert_100A := 0.025;
	EXPORT ThreshPercent_Alert_100B := 0.025;
	EXPORT ThreshPercent_Alert_100C := 0.025;
	EXPORT ThreshPercent_Alert_100D := 0.025;
	EXPORT ThreshPercent_Alert_100E := 0.025;
	EXPORT ThreshPercent_Alert_100F := 0.025;
	EXPORT ThreshPercent_Alert_200A := 0.025;
	EXPORT ThreshPercent_Alert_222A := 0.025;
	// Reason Code Thresholds
	EXPORT ThreshPercent_RC_01 := 0.010;
	EXPORT ThreshPercent_RC_02 := 0.750;
	EXPORT ThreshPercent_RC_03 := 0.750;
	EXPORT ThreshPercent_RC_04 := 0.250;
	EXPORT ThreshPercent_RC_05 := 0.010;
	EXPORT ThreshPercent_RC_06 := 2.250;
	EXPORT ThreshPercent_RC_07 := 1.000;
	EXPORT ThreshPercent_RC_08 := 3.250;
	EXPORT ThreshPercent_RC_09 := 0.250;
	EXPORT ThreshPercent_RC_10 := 15.500;
	EXPORT ThreshPercent_RC_11 := 2.250;
	EXPORT ThreshPercent_RC_12 := 0.250;
	EXPORT ThreshPercent_RC_13 := 0.010;
	EXPORT ThreshPercent_RC_14 := 0.500;
	EXPORT ThreshPercent_RC_15 := 0.250;
	EXPORT ThreshPercent_RC_16 := 1.000;
	EXPORT ThreshPercent_RC_17 := 0.010;
	EXPORT ThreshPercent_RC_19 := 1.150;
	EXPORT ThreshPercent_RC_20 := 1.500;
	EXPORT ThreshPercent_RC_21 := 0.010;
	EXPORT ThreshPercent_RC_22 := 0.010;
	EXPORT ThreshPercent_RC_23 := 0.050;
	EXPORT ThreshPercent_RC_24 := 3.250;
	EXPORT ThreshPercent_RC_25 := 6.500;
	EXPORT ThreshPercent_RC_26 := 2.250;
	EXPORT ThreshPercent_RC_27 := 23.000;
	EXPORT ThreshPercent_RC_28 := 4.000;
	EXPORT ThreshPercent_RC_29 := 0.750;
	EXPORT ThreshPercent_RC_30 := 1.500;
	EXPORT ThreshPercent_RC_31 := 0.500;
	EXPORT ThreshPercent_RC_32 := 0.150;
	EXPORT ThreshPercent_RC_33 := 0.010;
	EXPORT ThreshPercent_RC_34 := 9.250;
	EXPORT ThreshPercent_RC_35 := 0.250;
	EXPORT ThreshPercent_RC_36 := 5.350;
	EXPORT ThreshPercent_RC_37 := 0.750;
	EXPORT ThreshPercent_RC_38 := 1.000;
	EXPORT ThreshPercent_RC_39 := 0.010;
	EXPORT ThreshPercent_RC_40 := 0.250;
	EXPORT ThreshPercent_RC_41 := 0.750;
	EXPORT ThreshPercent_RC_42 := 7.000;
	EXPORT ThreshPercent_RC_43 := 5.500;
	EXPORT ThreshPercent_RC_44 := 1.000;
	EXPORT ThreshPercent_RC_45 := 0.010;
	EXPORT ThreshPercent_RC_46 := 0.035;
	EXPORT ThreshPercent_RC_47 := 0.010;
	EXPORT ThreshPercent_RC_48 := 0.350;
	EXPORT ThreshPercent_RC_49 := 0.350;
	EXPORT ThreshPercent_RC_50 := 0.015;
	EXPORT ThreshPercent_RC_51 := 2.250;
	EXPORT ThreshPercent_RC_52 := 1.750;
	EXPORT ThreshPercent_RC_53 := 0.035;
	EXPORT ThreshPercent_RC_54 := 0.010;
	EXPORT ThreshPercent_RC_55 := 0.500;
	EXPORT ThreshPercent_RC_56 := 0.750;
	EXPORT ThreshPercent_RC_57 := 1.750;
	EXPORT ThreshPercent_RC_58 := 0.010;
	EXPORT ThreshPercent_RC_59 := 0.010;
	EXPORT ThreshPercent_RC_5Q := 0.010;
	EXPORT ThreshPercent_RC_60 := 0.010;
	EXPORT ThreshPercent_RC_61 := 0.010;
	EXPORT ThreshPercent_RC_62 := 0.010;
	EXPORT ThreshPercent_RC_63 := 0.010;
	EXPORT ThreshPercent_RC_64 := 1.750;
	EXPORT ThreshPercent_RC_65 := 0.010;
	EXPORT ThreshPercent_RC_66 := 0.250;
	EXPORT ThreshPercent_RC_67 := 0.010;
	EXPORT ThreshPercent_RC_68 := 0.010;
	EXPORT ThreshPercent_RC_69 := 0.010;
	EXPORT ThreshPercent_RC_70 := 0.010;
	EXPORT ThreshPercent_RC_71 := 0.750;
	EXPORT ThreshPercent_RC_72 := 2.250;
	EXPORT ThreshPercent_RC_73 := 17.500;
	EXPORT ThreshPercent_RC_74 := 1.250;
	EXPORT ThreshPercent_RC_75 := 1.000;
	EXPORT ThreshPercent_RC_76 := 0.250;
	EXPORT ThreshPercent_RC_77 := 0.500;
	EXPORT ThreshPercent_RC_78 := 30.000;
	EXPORT ThreshPercent_RC_79 := 4.000;
	EXPORT ThreshPercent_RC_80 := 22.000;
	EXPORT ThreshPercent_RC_81 := 15.000;
	EXPORT ThreshPercent_RC_82 := 6.750;
	EXPORT ThreshPercent_RC_83 := 0.500;
	EXPORT ThreshPercent_RC_84 := 0.010;
	EXPORT ThreshPercent_RC_85 := 0.100;
	EXPORT ThreshPercent_RC_86 := 0.010;
	EXPORT ThreshPercent_RC_87 := 0.010;
	EXPORT ThreshPercent_RC_88 := 0.010;
	EXPORT ThreshPercent_RC_89 := 0.250;
	EXPORT ThreshPercent_RC_90 := 0.400;
	EXPORT ThreshPercent_RC_91 := 0.010;
	EXPORT ThreshPercent_RC_92 := 0.010;
	EXPORT ThreshPercent_RC_93 := 0.010;
	EXPORT ThreshPercent_RC_94 := 0.010;
	EXPORT ThreshPercent_RC_95 := 0.010;
	EXPORT ThreshPercent_RC_96 := 0.010;
	EXPORT ThreshPercent_RC_97 := 1.500;
	EXPORT ThreshPercent_RC_98 := 7.000;
	EXPORT ThreshPercent_RC_99 := 2.250;
	EXPORT ThreshPercent_RC_9A := 11.000;
	EXPORT ThreshPercent_RC_9B := 4.000;
	EXPORT ThreshPercent_RC_9C := 4.000;
	EXPORT ThreshPercent_RC_9D := 5.150;
	EXPORT ThreshPercent_RC_9E := 12.250;
	EXPORT ThreshPercent_RC_9F := 20.000;
	EXPORT ThreshPercent_RC_9G := 8.000;
	EXPORT ThreshPercent_RC_9H := 2.000;
	EXPORT ThreshPercent_RC_9I := 6.750;
	EXPORT ThreshPercent_RC_9J := 1.750;
	EXPORT ThreshPercent_RC_9K := 6.000;
	EXPORT ThreshPercent_RC_9L := 0.050;
	EXPORT ThreshPercent_RC_9M := 12.500;
	EXPORT ThreshPercent_RC_9N := 0.025;
	EXPORT ThreshPercent_RC_9O := 30.000;
	EXPORT ThreshPercent_RC_9P := 0.500;
	EXPORT ThreshPercent_RC_9Q := 6.000;
	EXPORT ThreshPercent_RC_9R := 3.000;
	EXPORT ThreshPercent_RC_9S := 0.350;
	EXPORT ThreshPercent_RC_9T := 3.000;
	EXPORT ThreshPercent_RC_9U := 0.650;
	EXPORT ThreshPercent_RC_9V := 0.250;
	EXPORT ThreshPercent_RC_9W := 4.150;
	EXPORT ThreshPercent_RC_9X := 3.250;
	EXPORT ThreshPercent_RC_A0 := 0.010;
	EXPORT ThreshPercent_RC_AR := 0.010;
	EXPORT ThreshPercent_RC_A1 := 0.010;
	EXPORT ThreshPercent_RC_A2 := 0.010;
	EXPORT ThreshPercent_RC_A3 := 0.010;
	EXPORT ThreshPercent_RC_A4 := 0.010;
	EXPORT ThreshPercent_RC_A5 := 0.010;
	EXPORT ThreshPercent_RC_A6 := 0.010;
	EXPORT ThreshPercent_RC_A7 := 0.010;
	EXPORT ThreshPercent_RC_A8 := 0.010;
	EXPORT ThreshPercent_RC_A9 := 0.010;
	EXPORT ThreshPercent_RC_B0 := 0.010; // B Zero
	EXPORT ThreshPercent_RC_BO := 1.500; // B O
	EXPORT ThreshPercent_RC_CB := 0.250;
	EXPORT ThreshPercent_RC_CC := 0.250;
	EXPORT ThreshPercent_RC_CL := 0.250;
	EXPORT ThreshPercent_RC_CO := 0.040;
	EXPORT ThreshPercent_RC_CR := 0.010;
	EXPORT ThreshPercent_RC_CZ := 0.250;
	EXPORT ThreshPercent_RC_DD := 1.100;
	EXPORT ThreshPercent_RC_DF := 2.500;
	EXPORT ThreshPercent_RC_DM := 0.300;
	EXPORT ThreshPercent_RC_DR := 0.010;
	EXPORT ThreshPercent_RC_DV := 0.075;
	EXPORT ThreshPercent_RC_EV := 4.000;
	EXPORT ThreshPercent_RC_FB := 0.010;
	EXPORT ThreshPercent_RC_FM := 0.010;
	EXPORT ThreshPercent_RC_FQ := 13.250;
	EXPORT ThreshPercent_RC_FR := 0.010;
	EXPORT ThreshPercent_RC_FV := 0.750;
	EXPORT ThreshPercent_RC_HA := 0.010;
	EXPORT ThreshPercent_RC_IA := 0.010;
	EXPORT ThreshPercent_RC_IB := 0.010;
	EXPORT ThreshPercent_RC_IC := 0.010;
	EXPORT ThreshPercent_RC_ID := 0.010;
	EXPORT ThreshPercent_RC_IE := 1.750;
	EXPORT ThreshPercent_RC_IF := 0.500;
	EXPORT ThreshPercent_RC_IG := 0.250;
	EXPORT ThreshPercent_RC_IH := 0.010;
	EXPORT ThreshPercent_RC_II := 4.000;
	EXPORT ThreshPercent_RC_IJ := 3.750;
	EXPORT ThreshPercent_RC_IK := 3.750;
	EXPORT ThreshPercent_RC_IR := 0.010;
	EXPORT ThreshPercent_RC_IS := 0.035;
	EXPORT ThreshPercent_RC_IT := 0.250;
	EXPORT ThreshPercent_RC_MI := 0.750;
	EXPORT ThreshPercent_RC_MN := 1.150;
	EXPORT ThreshPercent_RC_MO := 0.030;
	EXPORT ThreshPercent_RC_MS := 1.250;
	EXPORT ThreshPercent_RC_PA := 5.000;
	EXPORT ThreshPercent_RC_PH := 5.000;
	EXPORT ThreshPercent_RC_PN := 2.750;
	EXPORT ThreshPercent_RC_PO := 2.750;
	EXPORT ThreshPercent_RC_QA := 0.250;
	EXPORT ThreshPercent_RC_QB := 0.250;
	EXPORT ThreshPercent_RC_QC := 0.250;
	EXPORT ThreshPercent_RC_QD := 0.250;
	EXPORT ThreshPercent_RC_QE := 0.250;
	EXPORT ThreshPercent_RC_QF := 0.250;
	EXPORT ThreshPercent_RC_QG := 0.250;
	EXPORT ThreshPercent_RC_QH := 0.250;
	EXPORT ThreshPercent_RC_QI := 0.250;
	EXPORT ThreshPercent_RC_QJ := 0.250;
	EXPORT ThreshPercent_RC_QK := 0.250;
	EXPORT ThreshPercent_RC_QL := 0.250;
	EXPORT ThreshPercent_RC_QM := 0.250;
	EXPORT ThreshPercent_RC_PV := 8.500;
	EXPORT ThreshPercent_RC_RC := 1.000;
	EXPORT ThreshPercent_RC_RF := 1.000;
	EXPORT ThreshPercent_RC_RS := 1.000;
	EXPORT ThreshPercent_RC_S1 := 1.000;
	EXPORT ThreshPercent_RC_S2 := 1.000;
	EXPORT ThreshPercent_RC_S3 := 1.000;
	EXPORT ThreshPercent_RC_S4 := 1.000;
	EXPORT ThreshPercent_RC_S5 := 1.000;
	EXPORT ThreshPercent_RC_SA := 1.000;
	EXPORT ThreshPercent_RC_SC := 1.000;
	EXPORT ThreshPercent_RC_SN := 1.000;
	EXPORT ThreshPercent_RC_SR := 1.400;
	EXPORT ThreshPercent_RC_U1 := 1.000;
	EXPORT ThreshPercent_RC_U2 := 0.250;
	EXPORT ThreshPercent_RC_VE := 1.000;
	EXPORT ThreshPercent_RC_VL := 1.000;
	EXPORT ThreshPercent_RC_VR := 1.000;
	EXPORT ThreshPercent_RC_VV := 1.000;
	EXPORT ThreshPercent_RC_VX := 1.000;
	EXPORT ThreshPercent_RC_WL := 0.450;
	EXPORT ThreshPercent_RC_ZI := 1.000;
	// RiskView 2 Thresholds
	EXPORT ThreshPercent_RC_F00 := 0.025;
	EXPORT ThreshPercent_RC_F01 := 0.025;
	EXPORT ThreshPercent_RC_F02 := 0.025;
	EXPORT ThreshPercent_RC_F03 := 0.025;
	EXPORT ThreshPercent_RC_F04 := 0.025;
	EXPORT ThreshPercent_RC_C10 := 0.025;
	EXPORT ThreshPercent_RC_C11 := 0.025;
	EXPORT ThreshPercent_RC_C12 := 0.025;
	EXPORT ThreshPercent_RC_C13 := 0.025;
	EXPORT ThreshPercent_RC_C14 := 0.025;
	EXPORT ThreshPercent_RC_C15 := 0.025;
	EXPORT ThreshPercent_RC_C16 := 0.025;
	EXPORT ThreshPercent_RC_C17 := 0.025;
	EXPORT ThreshPercent_RC_C18 := 0.025;
	EXPORT ThreshPercent_RC_C19 := 0.025;
	EXPORT ThreshPercent_RC_C20 := 0.025;
	EXPORT ThreshPercent_RC_C21 := 0.025;
	EXPORT ThreshPercent_RC_C22 := 0.025;
	EXPORT ThreshPercent_RC_C23 := 0.025;
	EXPORT ThreshPercent_RC_D30 := 0.025;
	EXPORT ThreshPercent_RC_D31 := 0.025;
	EXPORT ThreshPercent_RC_D32 := 0.025;
	EXPORT ThreshPercent_RC_D33 := 0.025;
	EXPORT ThreshPercent_RC_D34 := 0.025;
	EXPORT ThreshPercent_RC_A40 := 0.025;
	EXPORT ThreshPercent_RC_A41 := 0.025;
	EXPORT ThreshPercent_RC_A42 := 0.025;
	EXPORT ThreshPercent_RC_A43 := 0.025;
	EXPORT ThreshPercent_RC_A44 := 0.025;
	EXPORT ThreshPercent_RC_A45 := 0.025;
	EXPORT ThreshPercent_RC_A46 := 0.025;
	EXPORT ThreshPercent_RC_A47 := 0.025;
	EXPORT ThreshPercent_RC_A48 := 0.025;
	EXPORT ThreshPercent_RC_A49 := 0.025;
	EXPORT ThreshPercent_RC_A50 := 0.025;
	EXPORT ThreshPercent_RC_A51 := 0.025;
	EXPORT ThreshPercent_RC_E55 := 0.025;
	EXPORT ThreshPercent_RC_E56 := 0.025;
	EXPORT ThreshPercent_RC_E57 := 0.025;
	EXPORT ThreshPercent_RC_I60 := 0.025;
	EXPORT ThreshPercent_RC_I61 := 0.025;
	EXPORT ThreshPercent_RC_S65 := 0.025;
	EXPORT ThreshPercent_RC_S66 := 0.025;
	EXPORT ThreshPercent_RC_L70 := 0.025;
	EXPORT ThreshPercent_RC_L71 := 0.025;
	EXPORT ThreshPercent_RC_L72 := 0.025;
	EXPORT ThreshPercent_RC_L73 := 0.025;
	EXPORT ThreshPercent_RC_L74 := 0.025;
	EXPORT ThreshPercent_RC_L75 := 0.025;
	EXPORT ThreshPercent_RC_L76 := 0.025;
	EXPORT ThreshPercent_RC_L77 := 0.025;
	EXPORT ThreshPercent_RC_L78 := 0.025;
	EXPORT ThreshPercent_RC_L79 := 0.025;
	EXPORT ThreshPercent_RC_L80 := 0.025;
	EXPORT ThreshPercent_RC_L81 := 0.025;
	EXPORT ThreshPercent_RC_P85 := 0.025;
	EXPORT ThreshPercent_RC_P86 := 0.025;
	EXPORT ThreshPercent_RC_P87 := 0.025;
	EXPORT ThreshPercent_RC_P88 := 0.025;
	EXPORT ThreshPercent_RC_P89 := 0.025;
	EXPORT ThreshPercent_RC_P90 := 0.025;
	// VerificationOfOccupancy Thresholds
	EXPORT ThreshPercent_VerificationOfOccupancyScore_00 := 1.000;
	EXPORT ThreshPercent_VerificationOfOccupancyScore_10_30 := 1.000;
	EXPORT ThreshPercent_VerificationOfOccupancyScore_40_60 := 1.000;
	EXPORT ThreshPercent_VerificationOfOccupancyScore_70_90 := 1.000;
	// PremiseAssociation Thresholds
	EXPORT ThreshPercent_PremiseAssociationScore_00 := 1.000;
	EXPORT ThreshPercent_PremiseAssociationScore_10_30 := 1.000;
	EXPORT ThreshPercent_PremiseAssociationScore_40_60 := 1.000;
	EXPORT ThreshPercent_PremiseAssociationScore_70_90 := 1.000;

	EXPORT Max_atmost := 1000;

EXPORT ds_Record := dataset([{1}], {unsigned a});

END;