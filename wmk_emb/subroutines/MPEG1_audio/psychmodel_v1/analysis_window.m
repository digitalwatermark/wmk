
% Revised by Peng Zhang, Tsinghua Univ., 2009-02-27
% C = flipud(C(:)); discarded
% see also: subband_filter_mpeg
%-------------------------------------------------------------------------------

%   old version: Table_analysis_window()
%   Initialize the analysis window used in the subband analysis.
%   The C coefficients are given in [1, pp. 68--69].
%   Author: Fabien A. P. Petitcolas

function C = analysis_window()

C = zeros(511, 1);      % not 512 here !!

                                      C(  1)=-0.000000477; C(  2)=-0.000000477; C(  3)=-0.000000477 ;
C(  4)=-0.000000477; C(  5)=-0.000000477; C(  6)=-0.000000477; C(  7)=-0.000000954 ;
C(  8)=-0.000000954; C(  9)=-0.000000954; C( 10)=-0.000000954; C( 11)=-0.000001431 ;
C( 12)=-0.000001431; C( 13)=-0.000001907; C( 14)=-0.000001907; C( 15)=-0.000002384 ;
C( 16)=-0.000002384; C( 17)=-0.000002861; C( 18)=-0.000003338; C( 19)=-0.000003338 ;
C( 20)=-0.000003815; C( 21)=-0.000004292; C( 22)=-0.000004768; C( 23)=-0.000005245 ;
C( 24)=-0.000006199; C( 25)=-0.000006676; C( 26)=-0.000007629; C( 27)=-0.000008106 ;
C( 28)=-0.000009060; C( 29)=-0.000010014; C( 30)=-0.000011444; C( 31)=-0.000012398 ;
C( 32)=-0.000013828; C( 33)=-0.000014782; C( 34)=-0.000016689; C( 35)=-0.000018120 ;
C( 36)=-0.000019550; C( 37)=-0.000021458; C( 38)=-0.000023365; C( 39)=-0.000025272 ;
C( 40)=-0.000027657; C( 41)=-0.000030041; C( 42)=-0.000032425; C( 43)=-0.000034809 ;
C( 44)=-0.000037670; C( 45)=-0.000040531; C( 46)=-0.000043392; C( 47)=-0.000046253 ;
C( 48)=-0.000049591; C( 49)=-0.000052929; C( 50)=-0.000055790; C( 51)=-0.000059605 ;
C( 52)=-0.000062943; C( 53)=-0.000066280; C( 54)=-0.000070095; C( 55)=-0.000073433 ;
C( 56)=-0.000076771; C( 57)=-0.000080585; C( 58)=-0.000083923; C( 59)=-0.000087261 ;
C( 60)=-0.000090599; C( 61)=-0.000093460; C( 62)=-0.000096321; C( 63)=-0.000099182 ;
C( 64)= 0.000101566; C( 65)= 0.000103951; C( 66)= 0.000105858; C( 67)= 0.000107288 ;
C( 68)= 0.000108242; C( 69)= 0.000108719; C( 70)= 0.000108719; C( 71)= 0.000108242 ;
C( 72)= 0.000106812; C( 73)= 0.000105381; C( 74)= 0.000102520; C( 75)= 0.000099182 ;
C( 76)= 0.000095367; C( 77)= 0.000090122; C( 78)= 0.000084400; C( 79)= 0.000077724 ;
C( 80)= 0.000069618; C( 81)= 0.000060558; C( 82)= 0.000050545; C( 83)= 0.000039577 ;
C( 84)= 0.000027180; C( 85)= 0.000013828; C( 86)=-0.000000954; C( 87)=-0.000017166 ;
C( 88)=-0.000034332; C( 89)=-0.000052929; C( 90)=-0.000072956; C( 91)=-0.000093937 ;
C( 92)=-0.000116348; C( 93)=-0.000140190; C( 94)=-0.000165462; C( 95)=-0.000191212 ;
C( 96)=-0.000218868; C( 97)=-0.000247478; C( 98)=-0.000277042; C( 99)=-0.000307560 ;
C(100)=-0.000339031; C(101)=-0.000371456; C(102)=-0.000404358; C(103)=-0.000438213 ;
C(104)=-0.000472546; C(105)=-0.000507355; C(106)=-0.000542164; C(107)=-0.000576973 ;
C(108)=-0.000611782; C(109)=-0.000646591; C(110)=-0.000680923; C(111)=-0.000714302 ;
C(112)=-0.000747204; C(113)=-0.000779152; C(114)=-0.000809669; C(115)=-0.000838757 ;
C(116)=-0.000866413; C(117)=-0.000891685; C(118)=-0.000915051; C(119)=-0.000935555 ;
C(120)=-0.000954151; C(121)=-0.000968933; C(122)=-0.000980854; C(123)=-0.000989437 ;
C(124)=-0.000994205; C(125)=-0.000995159; C(126)=-0.000991821; C(127)=-0.000983715 ;
C(128)= 0.000971317; C(129)= 0.000953674; C(130)= 0.000930786; C(131)= 0.000902653 ;
C(132)= 0.000868797; C(133)= 0.000829220; C(134)= 0.000783920; C(135)= 0.000731945 ;
C(136)= 0.000674248; C(137)= 0.000610352; C(138)= 0.000539303; C(139)= 0.000462532 ;
C(140)= 0.000378609; C(141)= 0.000288486; C(142)= 0.000191689; C(143)= 0.000088215 ;
C(144)=-0.000021458; C(145)=-0.000137329; C(146)=-0.000259876; C(147)=-0.000388145 ;
C(148)=-0.000522137; C(149)=-0.000661850; C(150)=-0.000806808; C(151)=-0.000956535 ;
C(152)=-0.001111031; C(153)=-0.001269817; C(154)=-0.001432419; C(155)=-0.001597881 ;
C(156)=-0.001766682; C(157)=-0.001937389; C(158)=-0.002110004; C(159)=-0.002283096 ;
C(160)=-0.002457142; C(161)=-0.002630711; C(162)=-0.002803326; C(163)=-0.002974033 ;
C(164)=-0.003141880; C(165)=-0.003306866; C(166)=-0.003467083; C(167)=-0.003622532 ;
C(168)=-0.003771782; C(169)=-0.003914356; C(170)=-0.004048824; C(171)=-0.004174709 ;
C(172)=-0.004290581; C(173)=-0.004395962; C(174)=-0.004489899; C(175)=-0.004570484 ;
C(176)=-0.004638195; C(177)=-0.004691124; C(178)=-0.004728317; C(179)=-0.004748821 ;
C(180)=-0.004752159; C(181)=-0.004737377; C(182)=-0.004703045; C(183)=-0.004649162 ;
C(184)=-0.004573822; C(185)=-0.004477024; C(186)=-0.004357815; C(187)=-0.004215240 ;
C(188)=-0.004049301; C(189)=-0.003858566; C(190)=-0.003643036; C(191)=-0.003401756 ;
C(192)= 0.003134727; C(193)= 0.002841473; C(194)= 0.002521515; C(195)= 0.002174854 ;
C(196)= 0.001800537; C(197)= 0.001399517; C(198)= 0.000971317; C(199)= 0.000515938 ;
C(200)= 0.000033379; C(201)=-0.000475883; C(202)=-0.001011848; C(203)=-0.001573563 ;
C(204)=-0.002161503; C(205)=-0.002774239; C(206)=-0.003411293; C(207)=-0.004072189 ;
C(208)=-0.004756451; C(209)=-0.005462170; C(210)=-0.006189346; C(211)=-0.006937027 ;
C(212)=-0.007703304; C(213)=-0.008487225; C(214)=-0.009287834; C(215)=-0.010103703 ;
C(216)=-0.010933399; C(217)=-0.011775017; C(218)=-0.012627602; C(219)=-0.013489246 ;
C(220)=-0.014358521; C(221)=-0.015233517; C(222)=-0.016112804; C(223)=-0.016994476 ;
C(224)=-0.017876148; C(225)=-0.018756866; C(226)=-0.019634247; C(227)=-0.020506859 ;
C(228)=-0.021372318; C(229)=-0.022228718; C(230)=-0.023074150; C(231)=-0.023907185 ;
C(232)=-0.024725437; C(233)=-0.025527000; C(234)=-0.026310921; C(235)=-0.027073860 ;
C(236)=-0.027815342; C(237)=-0.028532982; C(238)=-0.029224873; C(239)=-0.029890060 ;
C(240)=-0.030526638; C(241)=-0.031132698; C(242)=-0.031706810; C(243)=-0.032248020 ;
C(244)=-0.032754898; C(245)=-0.033225536; C(246)=-0.033659935; C(247)=-0.034055710 ;
C(248)=-0.034412861; C(249)=-0.034730434; C(250)=-0.035007000; C(251)=-0.035242081 ;
C(252)=-0.035435200; C(253)=-0.035586357; C(254)=-0.035694122; C(255)=-0.035758972 ;
C(256)= 0.035780907; C(257)= 0.035758972; C(258)= 0.035694122; C(259)= 0.035586357 ;
C(260)= 0.035435200; C(261)= 0.035242081; C(262)= 0.035007000; C(263)= 0.034730434 ;
C(264)= 0.034412861; C(265)= 0.034055710; C(266)= 0.033659935; C(267)= 0.033225536 ;
C(268)= 0.032754898; C(269)= 0.032248020; C(270)= 0.031706810; C(271)= 0.031132698 ;
C(272)= 0.030526638; C(273)= 0.029890060; C(274)= 0.029224873; C(275)= 0.028532982 ;
C(276)= 0.027815342; C(277)= 0.027073860; C(278)= 0.026310921; C(279)= 0.025527000 ;
C(280)= 0.024725437; C(281)= 0.023907185; C(282)= 0.023074150; C(283)= 0.022228718 ;
C(284)= 0.021372318; C(285)= 0.020506859; C(286)= 0.019634247; C(287)= 0.018756866 ;
C(288)= 0.017876148; C(289)= 0.016994476; C(290)= 0.016112804; C(291)= 0.015233517 ;
C(292)= 0.014358521; C(293)= 0.013489246; C(294)= 0.012627602; C(295)= 0.011775017 ;
C(296)= 0.010933399; C(297)= 0.010103703; C(298)= 0.009287834; C(299)= 0.008487225 ;
C(300)= 0.007703304; C(301)= 0.006937027; C(302)= 0.006189346; C(303)= 0.005462170 ;
C(304)= 0.004756451; C(305)= 0.004072189; C(306)= 0.003411293; C(307)= 0.002774239 ;
C(308)= 0.002161503; C(309)= 0.001573563; C(310)= 0.001011848; C(311)= 0.000475883 ;
C(312)=-0.000033379; C(313)=-0.000515938; C(314)=-0.000971317; C(315)=-0.001399517 ;
C(316)=-0.001800537; C(317)=-0.002174854; C(318)=-0.002521515; C(319)=-0.002841473 ;
C(320)= 0.003134727; C(321)= 0.003401756; C(322)= 0.003643036; C(323)= 0.003858566 ;
C(324)= 0.004049301; C(325)= 0.004215240; C(326)= 0.004357815; C(327)= 0.004477024 ;
C(328)= 0.004573822; C(329)= 0.004649162; C(330)= 0.004703045; C(331)= 0.004737377 ;
C(332)= 0.004752159; C(333)= 0.004748821; C(334)= 0.004728317; C(335)= 0.004691124 ;
C(336)= 0.004638195; C(337)= 0.004570484; C(338)= 0.004489899; C(339)= 0.004395962 ;
C(340)= 0.004290581; C(341)= 0.004174709; C(342)= 0.004048824; C(343)= 0.003914356 ;
C(344)= 0.003771782; C(345)= 0.003622532; C(346)= 0.003467083; C(347)= 0.003306866 ;
C(348)= 0.003141880; C(349)= 0.002974033; C(350)= 0.002803326; C(351)= 0.002630711 ;
C(352)= 0.002457142; C(353)= 0.002283096; C(354)= 0.002110004; C(355)= 0.001937389 ;
C(356)= 0.001766682; C(357)= 0.001597881; C(358)= 0.001432419; C(359)= 0.001269817 ;
C(360)= 0.001111031; C(361)= 0.000956535; C(362)= 0.000806808; C(363)= 0.000661850 ;
C(364)= 0.000522137; C(365)= 0.000388145; C(366)= 0.000259876; C(367)= 0.000137329 ;
C(368)= 0.000021458; C(369)=-0.000088215; C(370)=-0.000191689; C(371)=-0.000288486 ;
C(372)=-0.000378609; C(373)=-0.000462532; C(374)=-0.000539303; C(375)=-0.000610352 ;
C(376)=-0.000674248; C(377)=-0.000731945; C(378)=-0.000783920; C(379)=-0.000829220 ;
C(380)=-0.000868797; C(381)=-0.000902653; C(382)=-0.000930786; C(383)=-0.000953674 ;
C(384)= 0.000971317; C(385)= 0.000983715; C(386)= 0.000991821; C(387)= 0.000995159 ;
C(388)= 0.000994205; C(389)= 0.000989437; C(390)= 0.000980854; C(391)= 0.000968933 ;
C(392)= 0.000954151; C(393)= 0.000935555; C(394)= 0.000915051; C(395)= 0.000891685 ;
C(396)= 0.000866413; C(397)= 0.000838757; C(398)= 0.000809669; C(399)= 0.000779152 ;
C(400)= 0.000747204; C(401)= 0.000714302; C(402)= 0.000680923; C(403)= 0.000646591 ;
C(404)= 0.000611782; C(405)= 0.000576973; C(406)= 0.000542164; C(407)= 0.000507355 ;
C(408)= 0.000472546; C(409)= 0.000438213; C(410)= 0.000404358; C(411)= 0.000371456 ;
C(412)= 0.000339031; C(413)= 0.000307560; C(414)= 0.000277042; C(415)= 0.000247478 ;
C(416)= 0.000218868; C(417)= 0.000191212; C(418)= 0.000165462; C(419)= 0.000140190 ;
C(420)= 0.000116348; C(421)= 0.000093937; C(422)= 0.000072956; C(423)= 0.000052929 ;
C(424)= 0.000034332; C(425)= 0.000017166; C(426)= 0.000000954; C(427)=-0.000013828 ;
C(428)=-0.000027180; C(429)=-0.000039577; C(430)=-0.000050545; C(431)=-0.000060558 ;
C(432)=-0.000069618; C(433)=-0.000077724; C(434)=-0.000084400; C(435)=-0.000090122 ;
C(436)=-0.000095367; C(437)=-0.000099182; C(438)=-0.000102520; C(439)=-0.000105381 ;
C(440)=-0.000106812; C(441)=-0.000108242; C(442)=-0.000108719; C(443)=-0.000108719 ;
C(444)=-0.000108242; C(445)=-0.000107288; C(446)=-0.000105858; C(447)=-0.000103951 ;
C(448)= 0.000101566; C(449)= 0.000099182; C(450)= 0.000096321; C(451)= 0.000093460 ;
C(452)= 0.000090599; C(453)= 0.000087261; C(454)= 0.000083923; C(455)= 0.000080585 ;
C(456)= 0.000076771; C(457)= 0.000073433; C(458)= 0.000070095; C(459)= 0.000066280 ;
C(460)= 0.000062943; C(461)= 0.000059605; C(462)= 0.000055790; C(463)= 0.000052929 ;
C(464)= 0.000049591; C(465)= 0.000046253; C(466)= 0.000043392; C(467)= 0.000040531 ;
C(468)= 0.000037670; C(469)= 0.000034809; C(470)= 0.000032425; C(471)= 0.000030041 ;
C(472)= 0.000027657; C(473)= 0.000025272; C(474)= 0.000023365; C(475)= 0.000021458 ;
C(476)= 0.000019550; C(477)= 0.000018120; C(478)= 0.000016689; C(479)= 0.000014782 ;
C(480)= 0.000013828; C(481)= 0.000012398; C(482)= 0.000011444; C(483)= 0.000010014 ;
C(484)= 0.000009060; C(485)= 0.000008106; C(486)= 0.000007629; C(487)= 0.000006676 ;
C(488)= 0.000006199; C(489)= 0.000005245; C(490)= 0.000004768; C(491)= 0.000004292 ;
C(492)= 0.000003815; C(493)= 0.000003338; C(494)= 0.000003338; C(495)= 0.000002861 ;
C(496)= 0.000002384; C(497)= 0.000002384; C(498)= 0.000001907; C(499)= 0.000001907 ;
C(500)= 0.000001431; C(501)= 0.000001431; C(502)= 0.000000954; C(503)= 0.000000954 ;
C(504)= 0.000000954; C(505)= 0.000000954; C(506)= 0.000000477; C(507)= 0.000000477 ;
C(508)= 0.000000477; C(509)= 0.000000477; C(510)= 0.000000477; C(511)= 0.000000477 ;

% convert index 1~511 to 2~512; add C(0)
C = [0; C];

% --- EOF: analysis_window