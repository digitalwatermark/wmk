
% Peng Zhang, Tsinghua Univ., 2010-02-24
% see also: analysis_window
%-------------------------------------------------------------------------------

%   Initialize the synthesis window used in the subband synthesis.


function D = synthesis_window()

D = zeros(511, 1);      % not 512 here !!

                                       D(  1)=-0.000015259; D(  2)=-0.000015259; D(  3)=-0.000015259; 
D(  4)=-0.000015259; D(  5)=-0.000015259; D(  6)=-0.000015259; D(  7)=-0.000030518; 
D(  8)=-0.000030518; D(  9)=-0.000030518; D( 10)=-0.000030518; D( 11)=-0.000045776; 
D( 12)=-0.000045776; D( 13)=-0.000061035; D( 14)=-0.000061035; D( 15)=-0.000076294; 
D( 16)=-0.000076294; D( 17)=-0.000091553; D( 18)=-0.000106812; D( 19)=-0.000106812; 
D( 20)=-0.000122070; D( 21)=-0.000137329; D( 22)=-0.000152588; D( 23)=-0.000167847; 
D( 24)=-0.000198364; D( 25)=-0.000213623; D( 26)=-0.000244141; D( 27)=-0.000259399; 
D( 28)=-0.000289917; D( 29)=-0.000320435; D( 30)=-0.000366211; D( 31)=-0.000396729; 
D( 32)=-0.000442505; D( 33)=-0.000473022; D( 34)=-0.000534058; D( 35)=-0.000579834; 
D( 36)=-0.000625610; D( 37)=-0.000686646; D( 38)=-0.000747681; D( 39)=-0.000808716; 
D( 40)=-0.000885010; D( 41)=-0.000961304; D( 42)=-0.001037598; D( 43)=-0.001113892; 
D( 44)=-0.001205444; D( 45)=-0.001296997; D( 46)=-0.001388550; D( 47)=-0.001480103; 
D( 48)=-0.001586914; D( 49)=-0.001693726; D( 50)=-0.001785278; D( 51)=-0.001907349; 
D( 52)=-0.002014160; D( 53)=-0.002120972; D( 54)=-0.002243042; D( 55)=-0.002349854; 
D( 56)=-0.002456665; D( 57)=-0.002578735; D( 58)=-0.002685547; D( 59)=-0.002792358; 
D( 60)=-0.002899170; D( 61)=-0.002990723; D( 62)=-0.003082275; D( 63)=-0.003173828; 
D( 64)= 0.003250122; D( 65)= 0.003326416; D( 66)= 0.003387451; D( 67)= 0.003433228; 
D( 68)= 0.003463745; D( 69)= 0.003479004; D( 70)= 0.003479004; D( 71)= 0.003463745; 
D( 72)= 0.003417969; D( 73)= 0.003372192; D( 74)= 0.003280640; D( 75)= 0.003173828; 
D( 76)= 0.003051758; D( 77)= 0.002883911; D( 78)= 0.002700806; D( 79)= 0.002487183; 
D( 80)= 0.002227783; D( 81)= 0.001937866; D( 82)= 0.001617432; D( 83)= 0.001266479; 
D( 84)= 0.000869751; D( 85)= 0.000442505; D( 86)=-0.000030518; D( 87)=-0.000549316; 
D( 88)=-0.001098633; D( 89)=-0.001693726; D( 90)=-0.002334595; D( 91)=-0.003005981; 
D( 92)=-0.003723145; D( 93)=-0.004486084; D( 94)=-0.005294800; D( 95)=-0.006118774; 
D( 96)=-0.007003784; D( 97)=-0.007919312; D( 98)=-0.008865356; D( 99)=-0.009841919; 
D(100)=-0.010848999; D(101)=-0.011886597; D(102)=-0.012939453; D(103)=-0.014022827; 
D(104)=-0.015121460; D(105)=-0.016235352; D(106)=-0.017349243; D(107)=-0.018463135; 
D(108)=-0.019577026; D(109)=-0.020690918; D(110)=-0.021789551; D(111)=-0.022857666; 
D(112)=-0.023910522; D(113)=-0.024932861; D(114)=-0.025909424; D(115)=-0.026840210; 
D(116)=-0.027725220; D(117)=-0.028533936; D(118)=-0.029281616; D(119)=-0.029937744; 
D(120)=-0.030532837; D(121)=-0.031005859; D(122)=-0.031387329; D(123)=-0.031661987; 
D(124)=-0.031814575; D(125)=-0.031845093; D(126)=-0.031738281; D(127)=-0.031478882; 
D(128)= 0.031082153; D(129)= 0.030517578; D(130)= 0.029785156; D(131)= 0.028884888; 
D(132)= 0.027801514; D(133)= 0.026535034; D(134)= 0.025085449; D(135)= 0.023422241; 
D(136)= 0.021575928; D(137)= 0.019531250; D(138)= 0.017257690; D(139)= 0.014801025; 
D(140)= 0.012115479; D(141)= 0.009231567; D(142)= 0.006134033; D(143)= 0.002822876; 
D(144)=-0.000686646; D(145)=-0.004394531; D(146)=-0.008316040; D(147)=-0.012420654; 
D(148)=-0.016708374; D(149)=-0.021179199; D(150)=-0.025817871; D(151)=-0.030609131; 
D(152)=-0.035552979; D(153)=-0.040634155; D(154)=-0.045837402; D(155)=-0.051132202; 
D(156)=-0.056533813; D(157)=-0.061996460; D(158)=-0.067520142; D(159)=-0.073059082; 
D(160)=-0.078628540; D(161)=-0.084182739; D(162)=-0.089706421; D(163)=-0.095169067; 
D(164)=-0.100540161; D(165)=-0.105819702; D(166)=-0.110946655; D(167)=-0.115921021; 
D(168)=-0.120697021; D(169)=-0.125259399; D(170)=-0.129562378; D(171)=-0.133590698; 
D(172)=-0.137298584; D(173)=-0.140670776; D(174)=-0.143676758; D(175)=-0.146255493; 
D(176)=-0.148422241; D(177)=-0.150115967; D(178)=-0.151306152; D(179)=-0.151962280; 
D(180)=-0.152069092; D(181)=-0.151596069; D(182)=-0.150497437; D(183)=-0.148773193; 
D(184)=-0.146362305; D(185)=-0.143264771; D(186)=-0.139450073; D(187)=-0.134887695; 
D(188)=-0.129577637; D(189)=-0.123474121; D(190)=-0.116577148; D(191)=-0.108856201; 
D(192)= 0.100311279; D(193)= 0.090927124; D(194)= 0.080688477; D(195)= 0.069595337; 
D(196)= 0.057617187; D(197)= 0.044784546; D(198)= 0.031082153; D(199)= 0.016510010; 
D(200)= 0.001068115; D(201)=-0.015228271; D(202)=-0.032379150; D(203)=-0.050354004; 
D(204)=-0.069168091; D(205)=-0.088775635; D(206)=-0.109161377; D(207)=-0.130310059; 
D(208)=-0.152206421; D(209)=-0.174789429; D(210)=-0.198059082; D(211)=-0.221984863; 
D(212)=-0.246505737; D(213)=-0.271591187; D(214)=-0.297210693; D(215)=-0.323318481; 
D(216)=-0.349868774; D(217)=-0.376800537; D(218)=-0.404083252; D(219)=-0.431655884; 
D(220)=-0.459472656; D(221)=-0.487472534; D(222)=-0.515609741; D(223)=-0.543823242; 
D(224)=-0.572036743; D(225)=-0.600219727; D(226)=-0.628295898; D(227)=-0.656219482; 
D(228)=-0.683914185; D(229)=-0.711318970; D(230)=-0.738372803; D(231)=-0.765029907; 
D(232)=-0.791213989; D(233)=-0.816864014; D(234)=-0.841949463; D(235)=-0.866363525; 
D(236)=-0.890090942; D(237)=-0.913055420; D(238)=-0.935195923; D(239)=-0.956481934; 
D(240)=-0.976852417; D(241)=-0.996246338; D(242)=-1.014617920; D(243)=-1.031936646; 
D(244)=-1.048156738; D(245)=-1.063217163; D(246)=-1.077117920; D(247)=-1.089782715; 
D(248)=-1.101211548; D(249)=-1.111373901; D(250)=-1.120223999; D(251)=-1.127746582; 
D(252)=-1.133926392; D(253)=-1.138763428; D(254)=-1.142211914; D(255)=-1.144287109; 
D(256)= 1.144989014; D(257)= 1.144287109; D(258)= 1.142211914; D(259)= 1.138763428; 
D(260)= 1.133926392; D(261)= 1.127746582; D(262)= 1.120223999; D(263)= 1.111373901; 
D(264)= 1.101211548; D(265)= 1.089782715; D(266)= 1.077117920; D(267)= 1.063217163; 
D(268)= 1.048156738; D(269)= 1.031936646; D(270)= 1.014617920; D(271)= 0.996246338; 
D(272)= 0.976852417; D(273)= 0.956481934; D(274)= 0.935195923; D(275)= 0.913055420; 
D(276)= 0.890090942; D(277)= 0.866363525; D(278)= 0.841949463; D(279)= 0.816864014; 
D(280)= 0.791213989; D(281)= 0.765029907; D(282)= 0.738372803; D(283)= 0.711318970; 
D(284)= 0.683914185; D(285)= 0.656219482; D(286)= 0.628295898; D(287)= 0.600219727; 
D(288)= 0.572036743; D(289)= 0.543823242; D(290)= 0.515609741; D(291)= 0.487472534; 
D(292)= 0.459472656; D(293)= 0.431655884; D(294)= 0.404083252; D(295)= 0.376800537; 
D(296)= 0.349868774; D(297)= 0.323318481; D(298)= 0.297210693; D(299)= 0.271591187; 
D(300)= 0.246505737; D(301)= 0.221984863; D(302)= 0.198059082; D(303)= 0.174789429; 
D(304)= 0.152206421; D(305)= 0.130310059; D(306)= 0.109161377; D(307)= 0.088775635; 
D(308)= 0.069168091; D(309)= 0.050354004; D(310)= 0.032379150; D(311)= 0.015228271; 
D(312)=-0.001068115; D(313)=-0.016510010; D(314)=-0.031082153; D(315)=-0.044784546; 
D(316)=-0.057617187; D(317)=-0.069595337; D(318)=-0.080688477; D(319)=-0.090927124; 
D(320)= 0.100311279; D(321)= 0.108856201; D(322)= 0.116577148; D(323)= 0.123474121; 
D(324)= 0.129577637; D(325)= 0.134887695; D(326)= 0.139450073; D(327)= 0.143264771; 
D(328)= 0.146362305; D(329)= 0.148773193; D(330)= 0.150497437; D(331)= 0.151596069; 
D(332)= 0.152069092; D(333)= 0.151962280; D(334)= 0.151306152; D(335)= 0.150115967; 
D(336)= 0.148422241; D(337)= 0.146255493; D(338)= 0.143676758; D(339)= 0.140670776; 
D(340)= 0.137298584; D(341)= 0.133590698; D(342)= 0.129562378; D(343)= 0.125259399; 
D(344)= 0.120697021; D(345)= 0.115921021; D(346)= 0.110946655; D(347)= 0.105819702; 
D(348)= 0.100540161; D(349)= 0.095169067; D(350)= 0.089706421; D(351)= 0.084182739; 
D(352)= 0.078628540; D(353)= 0.073059082; D(354)= 0.067520142; D(355)= 0.061996460; 
D(356)= 0.056533813; D(357)= 0.051132202; D(358)= 0.045837402; D(359)= 0.040634155; 
D(360)= 0.035552979; D(361)= 0.030609131; D(362)= 0.025817871; D(363)= 0.021179199; 
D(364)= 0.016708374; D(365)= 0.012420654; D(366)= 0.008316040; D(367)= 0.004394531; 
D(368)= 0.000686646; D(369)=-0.002822876; D(370)=-0.006134033; D(371)=-0.009231567; 
D(372)=-0.012115479; D(373)=-0.014801025; D(374)=-0.017257690; D(375)=-0.019531250; 
D(376)=-0.021575928; D(377)=-0.023422241; D(378)=-0.025085449; D(379)=-0.026535034; 
D(380)=-0.027801514; D(381)=-0.028884888; D(382)=-0.029785156; D(383)=-0.030517578; 
D(384)= 0.031082153; D(385)= 0.031478882; D(386)= 0.031738281; D(387)= 0.031845093; 
D(388)= 0.031814575; D(389)= 0.031661987; D(390)= 0.031387329; D(391)= 0.031005859; 
D(392)= 0.030532837; D(393)= 0.029937744; D(394)= 0.029281616; D(395)= 0.028533936; 
D(396)= 0.027725220; D(397)= 0.026840210; D(398)= 0.025909424; D(399)= 0.024932861; 
D(400)= 0.023910522; D(401)= 0.022857666; D(402)= 0.021789551; D(403)= 0.020690918; 
D(404)= 0.019577026; D(405)= 0.018463135; D(406)= 0.017349243; D(407)= 0.016235352; 
D(408)= 0.015121460; D(409)= 0.014022827; D(410)= 0.012939453; D(411)= 0.011886597; 
D(412)= 0.010848999; D(413)= 0.009841919; D(414)= 0.008865356; D(415)= 0.007919312; 
D(416)= 0.007003784; D(417)= 0.006118774; D(418)= 0.005294800; D(419)= 0.004486084; 
D(420)= 0.003723145; D(421)= 0.003005981; D(422)= 0.002334595; D(423)= 0.001693726; 
D(424)= 0.001098633; D(425)= 0.000549316; D(426)= 0.000030518; D(427)=-0.000442505; 
D(428)=-0.000869751; D(429)=-0.001266479; D(430)=-0.001617432; D(431)=-0.001937866; 
D(432)=-0.002227783; D(433)=-0.002487183; D(434)=-0.002700806; D(435)=-0.002883911; 
D(436)=-0.003051758; D(437)=-0.003173828; D(438)=-0.003280640; D(439)=-0.003372192; 
D(440)=-0.003417969; D(441)=-0.003463745; D(442)=-0.003479004; D(443)=-0.003479004; 
D(444)=-0.003463745; D(445)=-0.003433228; D(446)=-0.003387451; D(447)=-0.003326416; 
D(448)= 0.003250122; D(449)= 0.003173828; D(450)= 0.003082275; D(451)= 0.002990723; 
D(452)= 0.002899170; D(453)= 0.002792358; D(454)= 0.002685547; D(455)= 0.002578735; 
D(456)= 0.002456665; D(457)= 0.002349854; D(458)= 0.002243042; D(459)= 0.002120972; 
D(460)= 0.002014160; D(461)= 0.001907349; D(462)= 0.001785278; D(463)= 0.001693726; 
D(464)= 0.001586914; D(465)= 0.001480103; D(466)= 0.001388550; D(467)= 0.001296997; 
D(468)= 0.001205444; D(469)= 0.001113892; D(470)= 0.001037598; D(471)= 0.000961304; 
D(472)= 0.000885010; D(473)= 0.000808716; D(474)= 0.000747681; D(475)= 0.000686646; 
D(476)= 0.000625610; D(477)= 0.000579834; D(478)= 0.000534058; D(479)= 0.000473022; 
D(480)= 0.000442505; D(481)= 0.000396729; D(482)= 0.000366211; D(483)= 0.000320435; 
D(484)= 0.000289917; D(485)= 0.000259399; D(486)= 0.000244141; D(487)= 0.000213623; 
D(488)= 0.000198364; D(489)= 0.000167847; D(490)= 0.000152588; D(491)= 0.000137329; 
D(492)= 0.000122070; D(493)= 0.000106812; D(494)= 0.000106812; D(495)= 0.000091553; 
D(496)= 0.000076294; D(497)= 0.000076294; D(498)= 0.000061035; D(499)= 0.000061035; 
D(500)= 0.000045776; D(501)= 0.000045776; D(502)= 0.000030518; D(503)= 0.000030518; 
D(504)= 0.000030518; D(505)= 0.000030518; D(506)= 0.000015259; D(507)= 0.000015259; 
D(508)= 0.000015259; D(509)= 0.000015259; D(510)= 0.000015259; D(511)= 0.000015259; 

% convert index 1~511 to 2~512; add D(0)
D = [0; D];

% --- EOF: synthesis_window
