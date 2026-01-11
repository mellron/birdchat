<%@ Control Language="c#" AutoEventWireup="True" Codebehind="COFAFSLoansRpt.ascx.cs" Inherits="USBank.USBnet.Treasury.Web.FTP.Reports.COFAFSLoansRpt" TargetSchema="http://schemas.microsoft.com/intellisense/ie5"%>
<LINK href="../../Support/AppStyles.css" type="text/css" rel="stylesheet">
<style type="text/css">
    .auto-style1 {
        height: 27px;
    }
    .auto-style2 {
        font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
        font-size: 12px;
        font-weight: bold;
        color: #FFFFFF;
        background-color: #0B76AA;
        border: 2px solid #000000;
        height: 22px;
    }
    .auto-style3 {
        height: 134px;
    }
    .COFAF_SuppressSection { display:none }
</style>
<script type="text/javascript">
	

</script>
<TABLE id="Table1" cellSpacing="4" cols="1" cellPadding="4" width="100%" border="0">
	<TR>
		<TD class="appUrgent" align="center" rowSpan="2">INTERNAL<BR>
			USE<BR>
			ONLY</TD>
		<TD align="center" colSpan="2">
			<P class="appPageTitle">CORPORATE TREASURY<BR>
				DAILY MATCHED MATURITY COST OF FUNDS (MMCOF) &amp; FUNDS TRANSFER<BR>
				PRICING (FTP)</P>
		</TD>
	</TR>
	<TR>
		<TD class="appTextItalic" align="center">Please call 612-303-2875 with questions or 
			update requests</TD>
		<TD align="right">
			<P><asp:label id="InsertDTLabel" CssClass="appMessage" runat="server"></asp:label></P>
		</TD>
	</TR>
</TABLE>
<TABLE id="Table2" cellSpacing="4" cellPadding="4" width="100%" border="0">
	<TR>
		<TD class="appPageTitle14" align="center" colSpan="3">COMMERCIAL MATCHED MATURITY 
			COST OF FUNDS - FIXED RATE LOANS</TD>
	</TR>
	<TR>
		<TD class="TableHeaderText" align="center" colSpan="3">Equal Monthly Payment 
			Amortization</TD>
	</TR>
	<TR>
		<TD vAlign="top" width="75%" colSpan="2"><asp:datagrid id="EqualPaymentAmortizationGrid" CssClass="appText" runat="server" AutoGenerateColumns="False"
				Width="100%">
				<AlternatingItemStyle HorizontalAlign="Center" CssClass="AlternateTableRow"></AlternatingItemStyle>
				<ItemStyle HorizontalAlign="Center"></ItemStyle>
				<HeaderStyle CssClass="TableHeaderText"></HeaderStyle>
				<Columns>
					<asp:BoundColumn DataField="TermDESC" HeaderText="&lt;BR&gt;Next Reprice/&lt;BR&gt;Orig Term"></asp:BoundColumn>
					<asp:BoundColumn DataField="BulletPCT" HeaderText="Bullet" DataFormatString="{0:P2}"></asp:BoundColumn>
					<asp:BoundColumn DataField="FullAmortPCT" HeaderText="Full&lt;BR&gt;Amort" DataFormatString="{0:P2}"></asp:BoundColumn>
					<asp:BoundColumn DataField="5YearAmortPCT" HeaderText="5 Yr.&lt;BR&gt;Amort" DataFormatString="{0:P2}"></asp:BoundColumn>
					<asp:BoundColumn DataField="10YearAmortPCT" HeaderText="10 Yr.&lt;BR&gt;Amort" DataFormatString="{0:P2}"></asp:BoundColumn>
					<asp:BoundColumn DataField="15YearAmortPCT" HeaderText="15 Yr.&lt;BR&gt;Amort" DataFormatString="{0:P2}"></asp:BoundColumn>
					<asp:BoundColumn DataField="20YearAmortPCT" HeaderText="20 Yr.&lt;BR&gt;Amort" DataFormatString="{0:P2}"></asp:BoundColumn>
					<asp:BoundColumn DataField="25YearAmortPCT" HeaderText="25 Yr.&lt;BR&gt;Amort" DataFormatString="{0:P2}"></asp:BoundColumn>
				</Columns>
			</asp:datagrid></TD>
		<TD vAlign="top" noWrap width="25%">
			<table>
				<tr>
					<TD class="appText" align="left">Basis point cost for additional options<BR>
						(Assumes Full Amortization)</TD>
				</tr>
				<tr>
					<TD class="SectionTitle" align="center">Forward Rate Lock</TD>
				</tr>
				<tr>
					<td noWrap><asp:datagrid id="ForwardRateLockGrid" CssClass="appText" runat="server" AutoGenerateColumns="False"
							Width="100%">
							<AlternatingItemStyle HorizontalAlign="Center" CssClass="AlternateTableRow"></AlternatingItemStyle>
							<ItemStyle HorizontalAlign="Center"></ItemStyle>
							<HeaderStyle CssClass="TableHeaderText"></HeaderStyle>
							<Columns>
								<asp:BoundColumn DataField="TermDESC" HeaderText="Original&lt;BR&gt;Term&lt;BR&gt;(years)">
									<ItemStyle Wrap="False"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="1MonthPCT" HeaderText="1 mo." DataFormatString="{0:P2}">
									<ItemStyle Wrap="False"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="2MonthPCT" HeaderText="2 mo." DataFormatString="{0:P2}">
									<ItemStyle Wrap="False"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="3MonthPCT" HeaderText="3 mo." DataFormatString="{0:P2}">
									<ItemStyle Wrap="False"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="6MonthPCT" HeaderText="6 mo." DataFormatString="{0:P2}">
									<ItemStyle Wrap="False"></ItemStyle>
								</asp:BoundColumn>
							</Columns>
						</asp:datagrid></td>
				</tr>
				<tr>
					<TD class="SectionTitle" align="center">Adjustment for Prepayment Waiver</TD>
				</tr>
				<tr>
					<td><asp:datagrid id="COFAdjustmentGrid" CssClass="appText" runat="server" AutoGenerateColumns="False"
							Width="100%">
							<AlternatingItemStyle HorizontalAlign="Center" CssClass="AlternateTableRow"></AlternatingItemStyle>
							<ItemStyle HorizontalAlign="Center"></ItemStyle>
							<HeaderStyle CssClass="TableHeaderText"></HeaderStyle>
							<Columns>
								<asp:BoundColumn DataField="TermDESC" HeaderText="Term&lt;BR&gt;(years)"></asp:BoundColumn>
								<asp:BoundColumn DataField="InterestOnlyPCT" HeaderText="Interest&lt;BR&gt;Only" DataFormatString="{0:P2}"></asp:BoundColumn>
								<asp:BoundColumn DataField="FullAmortPCT" HeaderText="Full&lt;BR&gt;Amortization" DataFormatString="{0:P2}"></asp:BoundColumn>
							</Columns>
						</asp:datagrid></td>
				</tr>
			</table>
		</TD>
	</TR>
</TABLE>
<TABLE id="Table3" cellSpacing="4" cellPadding="4" width="100%" border="0">
	<asp:panel id="PanelRecsFound1" runat="server" Visible="true">
		<TBODY>
			<TR>
				<TD id="Instructions1">
					<div class="appTinyText" id="InstructionsText1" runat="server"/>
					
				</TD>
			</TR>
	</asp:panel><asp:panel id="PanelRecsNF1" runat="server" Visible="false">
		<TR>
			<TD class="appMessage">Rates do not exist for the selected date.
			</TD>
		</TR>
	</asp:panel></TBODY></TABLE>

<TABLE id="Table4" cellSpacing="4" cellPadding="4" width="100%" border="0">

    <!-- ******************************* NOTE: CHANGE ********************************************************** -->

	<TR>
		<TD class="appPageTitle14" align="left">FLOATING RATE INDEXED COST OF 
			FUNDS (INCLUDE TERM ISSUANCE PREMIUM ADD-ON OR CONTINGENT FUNDING ADJUSTMENT (CFA))</TD>
	</TR>
	<TR>
		<td>
			<table style="width:100%;">
				<tr>
					<TD class="auto-style2" align="center" width="15%">U.S. Bank Money Market</TD>
					<TD class="auto-style2" align="center" width="15%">U.S. Bank Prime</TD>
					<TD class="auto-style2" align="center" width="15%">SOFR – Secured Overnight Funding Rate and Term</TD>
				</tr>
				<TR>
					<TD vAlign="top" width="12%" class="auto-style3"><asp:datagrid id="USMoneyMarketGrid" CssClass="appText" runat="server" AutoGenerateColumns="False"
							Width="100%">
							 
							<AlternatingItemStyle HorizontalAlign="Center" CssClass="AlternateTableRow"></AlternatingItemStyle>
							<ItemStyle HorizontalAlign="Center"></ItemStyle>
							<HeaderStyle CssClass="TableHeaderText"></HeaderStyle>
							<Columns>
								<asp:BoundColumn DataField="FreqDESC" HeaderText="Reprice&lt;BR&gt;Freq."><ItemStyle CssClass="TDNoBoarder" /></asp:BoundColumn>
								<asp:BoundColumn DataField="FreqRateTermValues" HeaderText="Rate" DataFormatString="{0:P2}">
									<ItemStyle Wrap="False"></ItemStyle>
									<ItemStyle CssClass="TDNoBoarder" />
								</asp:BoundColumn>
								<asp:BoundColumn DataField="TermDESC" HeaderText="Tenor"><ItemStyle CssClass="TDNoRightBoarder" /></asp:BoundColumn>
								<asp:BoundColumn DataField="RateTermValues" HeaderText="TIP" DataFormatString="{0:P2}">
									<ItemStyle Wrap="False"></ItemStyle>
									<ItemStyle CssClass="TDNoBoarder" />
								</asp:BoundColumn>
							</Columns>
						</asp:datagrid>
					</TD>
					<TD vAlign="top" align="left" width="15%" class="auto-style3">
						<asp:datagrid id="PrimeLiquidityGrid" CssClass="appText" runat="server" AutoGenerateColumns="False"
							Width="100%">
							<AlternatingItemStyle HorizontalAlign="Center" CssClass="AlternateTableRow"></AlternatingItemStyle>
							<ItemStyle HorizontalAlign="Center"></ItemStyle>
							<HeaderStyle CssClass="TableHeaderText"></HeaderStyle>
							<FooterStyle Font-Bold="True" HorizontalAlign="Left"></FooterStyle>
							<Columns>
								<asp:BoundColumn DataField="FreqDESC" HeaderText="Contract&lt;BR&gt;Length"><ItemStyle CssClass="TDNoBoarder" /></asp:BoundColumn>
								<asp:BoundColumn DataField="FreqRateTermValues" HeaderText="Rate" DataFormatString="{0:P2}">
									<ItemStyle Wrap="False"></ItemStyle>
									<ItemStyle CssClass="TDNoBoarder" />
								</asp:BoundColumn>
								<asp:BoundColumn DataField="TermDESC" HeaderText="Tenor"><ItemStyle CssClass="TDNoRightBoarder" /></asp:BoundColumn>
								<asp:BoundColumn DataField="RateTermValues" HeaderText="TIP" DataFormatString="{0:P2}">
									<ItemStyle Wrap="False"></ItemStyle>
									<ItemStyle CssClass="TDNoBoarder" />
								</asp:BoundColumn>
							</Columns>
					    </asp:datagrid>
					</TD>		
					<!-- TPP-4812 merged both SOFR sections into one .  SOFR – Secured Overnight Funding Rate and Term< -->
					<TD vAlign="top" align="left" width="15%" class="auto-style3">
						  <asp:datagrid id="OverNightSOFRGrid" CssClass="appText" runat="server" AutoGenerateColumns="False" Width="100%">
							<AlternatingItemStyle HorizontalAlign="Center" CssClass="AlternateTableRow"></AlternatingItemStyle>
							<ItemStyle HorizontalAlign="Center"></ItemStyle>
							<HeaderStyle CssClass="TableHeaderText"></HeaderStyle>
							<FooterStyle Font-Bold="True" HorizontalAlign="Left"></FooterStyle>
							<Columns>
								<asp:BoundColumn DataField="FreqDESC" HeaderText="Reprice&lt;BR&gt;Freq."><ItemStyle CssClass="TDNoBoarder" /></asp:BoundColumn>
								<asp:BoundColumn DataField="FreqRateTermValues" HeaderText="Rate" DataFormatString="{0:P4}">
									<ItemStyle Wrap="False"></ItemStyle>
									<ItemStyle CssClass="TDNoBoarder" />
								</asp:BoundColumn>
								<asp:BoundColumn DataField="TermDESC" HeaderText="Tenor"><ItemStyle CssClass="TDNoRightBoarder" /></asp:BoundColumn>
								<asp:BoundColumn DataField="RateTermValues" HeaderText="TIP" DataFormatString="{0:P2}">
									<ItemStyle Wrap="False"></ItemStyle>
									<ItemStyle CssClass="TDNoBoarder" />
								</asp:BoundColumn>
							</Columns>
						</asp:datagrid>
					</TD>
					<!-- Removed TPP-4812 Libor no longer required -->
					<!--<TD vAlign="top" width="12%" class="auto-style3">
					 
						<asp:datagrid id="LiborFloatingGrid" CssClass="appText" runat="server" AutoGenerateColumns="False" Width="100%">
							<FooterStyle Font-Bold="True" HorizontalAlign="Left"></FooterStyle>
							<AlternatingItemStyle HorizontalAlign="Center" CssClass="AlternateTableRow"></AlternatingItemStyle>
							<ItemStyle HorizontalAlign="Center"></ItemStyle>
							<HeaderStyle CssClass="TableHeaderText"></HeaderStyle>
							<Columns>
								<asp:BoundColumn DataField="FreqDESC" HeaderText="Reprice&lt;BR&gt;Freq."><ItemStyle CssClass="TDNoBoarder" /></asp:BoundColumn>
								<asp:BoundColumn DataField="FreqRateTermValues" HeaderText="Rate" DataFormatString="{0:P5}">
									<ItemStyle Wrap="False"></ItemStyle>
									<ItemStyle CssClass="TDNoBoarder" />
								</asp:BoundColumn>
								<asp:BoundColumn DataField="TermDESC" HeaderText="Tenor" ><ItemStyle CssClass="TDNoRightBoarder" />
								</asp:BoundColumn>
								<asp:BoundColumn DataField="RateTermValues" HeaderText="TIP" DataFormatString="{0:P2}">
										<ItemStyle Wrap="False"></ItemStyle>
										<ItemStyle CssClass="TDNoBoarder" />
								</asp:BoundColumn>
							</Columns>
					    </asp:datagrid>
 
					</TD> -->
					
			 

				</TR>
			</table>
		</td>
	</TR>
	<TR>
		<td>
			<asp:table ID="tblBSBYPrevouse" runat="server"  style="width:100%;">
				<asp:TableRow>
					<asp:TableCell class="auto-style2" align="center" width="15%"><%=m_sBSBYPrevouse%></asp:TableCell>
					<asp:TableCell class="auto-style2" align="center" width="15%"></asp:TableCell>
					<asp:TableCell class="auto-style2" align="center" width="15%"></asp:TableCell>
				</asp:TableRow>
				<asp:TableRow>
					<asp:TableCell vAlign="top" align="left" width="15%" class="auto-style3">
						<asp:datagrid id="BSBYGrid" CssClass="appText" runat="server" AutoGenerateColumns="False"
							Width="100%">
							<AlternatingItemStyle HorizontalAlign="Center" CssClass="AlternateTableRow"></AlternatingItemStyle>
							<ItemStyle HorizontalAlign="Center"></ItemStyle>
							<HeaderStyle CssClass="TableHeaderText"></HeaderStyle>
							<FooterStyle Font-Bold="True" HorizontalAlign="Left"></FooterStyle>
							<Columns>
								<asp:BoundColumn DataField="FreqDESC" HeaderText="Reprice&lt;BR&gt;Freq."><ItemStyle CssClass="TDNoBoarder" /></asp:BoundColumn>
								<asp:BoundColumn DataField="FreqRateTermValues" HeaderText="Rate" DataFormatString="{0:P5}">
									<ItemStyle Wrap="False"></ItemStyle>
									<ItemStyle CssClass="TDNoBoarder" />
								</asp:BoundColumn>
								<asp:BoundColumn DataField="TermDESC" HeaderText="Tenor"><ItemStyle CssClass="TDNoRightBoarder" /></asp:BoundColumn>
								<asp:BoundColumn DataField="RateTermValues" HeaderText="TIP" DataFormatString="{0:P2}">
									<ItemStyle Wrap="False"></ItemStyle>
									<ItemStyle CssClass="TDNoBoarder" />
								</asp:BoundColumn>
							</Columns>
					    </asp:datagrid>
					</asp:TableCell>
					<asp:TableCell vAlign="top" width="12%" class="auto-style3">
						<!-- TPP-4812 hiding this grid.  No longer needed, but just in case buisness line changes their minds -->
						 <asp:datagrid id="SOFRGrid" CssClass="appText" runat="server" AutoGenerateColumns="False"
							Width="100%">
							<AlternatingItemStyle HorizontalAlign="Center" CssClass="AlternateTableRow"></AlternatingItemStyle>
							<ItemStyle HorizontalAlign="Center"></ItemStyle>
							<HeaderStyle CssClass="TableHeaderText"></HeaderStyle>

							<Columns>
								<asp:BoundColumn DataField="FreqDESC" HeaderText="Reprice&lt;BR&gt;Freq."><ItemStyle CssClass="TDNoBoarder" /></asp:BoundColumn>
								<asp:BoundColumn DataField="FreqRateTermValues" HeaderText="Rate" DataFormatString="{0:P5}">
									<ItemStyle Wrap="False"></ItemStyle>
									<ItemStyle CssClass="TDNoBoarder" />
								</asp:BoundColumn>
								<asp:BoundColumn DataField="TermDESC" HeaderText="Tenor"><ItemStyle CssClass="TDNoRightBoarder" /></asp:BoundColumn>
								<asp:BoundColumn DataField="RateTermValues" HeaderText="TIP" DataFormatString="{0:P2}">
									<ItemStyle Wrap="False"></ItemStyle>
									<ItemStyle CssClass="TDNoBoarder" />
								</asp:BoundColumn>
							</Columns>
						</asp:datagrid>
					</asp:TableCell>

					<asp:TableCell vAlign="top" width="12%" class="auto-style3">

					</asp:TableCell>

				</asp:TableRow>
			</asp:table>
		</td>
	</TR>

	<TR>
		<td>
			<asp:table runat="server" ID="tblAmeriborEFFR" style="width:100%;">
				<asp:TableRow>
					<asp:TableCell class="auto-style2" align="center" width="15%">Term AMERIBOR</asp:TableCell>
					<asp:TableCell class="auto-style2" align="center" width="15%">Overnight AMERIBOR</asp:TableCell>
					<asp:TableCell class="auto-style2" align="center" width="15%">EFFR - Effective Federal Funds Rate</asp:TableCell>
					
				</asp:TableRow>
				<asp:TableRow>
		 
                   <asp:TableCell vAlign="top" width="12%" class="auto-style3"><asp:datagrid id="AmeriborGrid" CssClass="appText" runat="server" AutoGenerateColumns="False"
							Width="100%">
							<AlternatingItemStyle HorizontalAlign="Center" CssClass="AlternateTableRow"></AlternatingItemStyle>
							<ItemStyle HorizontalAlign="Center"></ItemStyle>
							<HeaderStyle CssClass="TableHeaderText"></HeaderStyle>

							<Columns>
								<asp:BoundColumn DataField="FreqDESC" HeaderText="Reprice&lt;BR&gt;Freq."><ItemStyle CssClass="TDNoBoarder" /></asp:BoundColumn>
								<asp:BoundColumn DataField="FreqRateTermValues" HeaderText="Rate" DataFormatString="{0:P5}">
									<ItemStyle Wrap="False"></ItemStyle>
									<ItemStyle CssClass="TDNoBoarder" />
								</asp:BoundColumn>
								<asp:BoundColumn DataField="TermDESC" HeaderText="Tenor"><ItemStyle CssClass="TDNoRightBoarder" /></asp:BoundColumn>
								<asp:BoundColumn DataField="RateTermValues" HeaderText="TIP" DataFormatString="{0:P2}">
									<ItemStyle Wrap="False"></ItemStyle>
									<ItemStyle CssClass="TDNoBoarder" />
								</asp:BoundColumn>
							</Columns>
						</asp:datagrid>
					</asp:TableCell>


            
					<asp:TableCell vAlign="top" width="12%" class="auto-style3">
						 <asp:datagrid id="OverNightAMERIBORGrid" CssClass="appText" runat="server" AutoGenerateColumns="False" Width="100%">
							<AlternatingItemStyle HorizontalAlign="Center" CssClass="AlternateTableRow"></AlternatingItemStyle>
							<ItemStyle HorizontalAlign="Center"></ItemStyle>
							<HeaderStyle CssClass="TableHeaderText"></HeaderStyle>

							<Columns>
								<asp:BoundColumn DataField="FreqDESC" HeaderText="Reprice&lt;BR&gt;Freq."><ItemStyle CssClass="TDNoBoarder" /></asp:BoundColumn>
								<asp:BoundColumn DataField="FreqRateTermValues" HeaderText="Rate" DataFormatString="{0:P5}">
									<ItemStyle Wrap="False"></ItemStyle>
									<ItemStyle CssClass="TDNoBoarder" />
								</asp:BoundColumn>
								<asp:BoundColumn DataField="TermDESC" HeaderText="Tenor"><ItemStyle CssClass="TDNoRightBoarder" /></asp:BoundColumn>
								<asp:BoundColumn DataField="RateTermValues" HeaderText="TIP" DataFormatString="{0:P2}">
									<ItemStyle Wrap="False"></ItemStyle>
									<ItemStyle CssClass="TDNoBoarder" />
								</asp:BoundColumn>
							</Columns>
						</asp:datagrid>
					</asp:TableCell>





					<asp:TableCell vAlign="top" align="left" width="15%" class="auto-style3"><asp:datagrid id="EFFRGrid" CssClass="appText" runat="server" AutoGenerateColumns="False"
							Width="100%">
							<AlternatingItemStyle HorizontalAlign="Center" CssClass="AlternateTableRow"></AlternatingItemStyle>
							<ItemStyle HorizontalAlign="Center"></ItemStyle>
							<HeaderStyle CssClass="TableHeaderText"></HeaderStyle>
							<FooterStyle Font-Bold="True" HorizontalAlign="Left"></FooterStyle>
							<Columns>
								<asp:BoundColumn DataField="FreqDESC" HeaderText="Reprice&lt;BR&gt;Freq."><ItemStyle CssClass="TDNoBoarder" /></asp:BoundColumn>
								<asp:BoundColumn DataField="FreqRateTermValues" HeaderText="Rate" DataFormatString="{0:P2}">
									<ItemStyle Wrap="False"></ItemStyle>
									<ItemStyle CssClass="TDNoBoarder" />
								</asp:BoundColumn>
								<asp:BoundColumn DataField="TermDESC" HeaderText="Tenor"><ItemStyle CssClass="TDNoRightBoarder" /></asp:BoundColumn>
								<asp:BoundColumn DataField="RateTermValues" HeaderText="TIP" DataFormatString="{0:P2}">
									<ItemStyle Wrap="False"></ItemStyle>
									<ItemStyle CssClass="TDNoBoarder" />
								</asp:BoundColumn>
							</Columns>
						</asp:datagrid>
					</asp:TableCell>
				</asp:TableRow>
			</asp:table>
		</td>
	</TR>
</TABLE>

<TABLE id="Table5" cellSpacing="4" cellPadding="4" width="100%" border="0">

    <!-- ******************************* NOTE: CHANGE ********************************************************** -->

	<TR>
		<td>
			<table style="width:100%;">
				<tr>
					<TD class="SectionTitle" align="center" width="50%">CFA for Unfunded Commitments</TD>
					<TD class="SectionTitle" align="center" width="50%">CONTINGENT CAPITAL ADJUSTMENT BY STANDARDIZED RISK-WEIGHT</TD>	
				</tr>
				<TR>
					<TD vAlign="top" align="left" width="50%"> 
                        <asp:datagrid id="StoredAssetGrid0" 
                            CssClass="appText" runat="server" AutoGenerateColumns="False"
							Width="100%"  >
							 
							<AlternatingItemStyle HorizontalAlign="Center" CssClass="AlternateTableRow"></AlternatingItemStyle>
							<ItemStyle HorizontalAlign="Center"></ItemStyle>
							<HeaderStyle CssClass="TableHeaderText"></HeaderStyle>
							<Columns>
								<asp:BoundColumn DataField="Term" HeaderText="Term">
									<HeaderStyle Width="10%"></HeaderStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="Retail" HeaderText="Retail&lt;BR&gt;(5%)" DataFormatString="{0:P2}">
									<HeaderStyle Width="18%"></HeaderStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="Wholesale" 
                                    HeaderText="Wholesale&lt;BR&gt;Credit&lt;BR&gt;Facilities&lt;BR&gt;(10%)^" DataFormatString="{0:P2}">
									<HeaderStyle Width="12%"></HeaderStyle>
								</asp:BoundColumn>
                                <asp:BoundColumn DataField="liquidityFinancial" 
                                    
                                    HeaderText="Wholesale&lt;BR&gt;Liquidity&lt;BR&gt;Facilities&lt;BR&gt;(30%)^^" 
                                    DataFormatString="{0:P2}">
									<HeaderStyle Width="12%"></HeaderStyle>
								</asp:BoundColumn>
                                <asp:BoundColumn DataField="DepositoryFinancial" 
                                    
                                    HeaderText="Non-Bank&lt;BR&gt;Financial&lt;BR&gt;Credit&lt;BR&gt;Facilities&lt;BR&gt;(40%)^^^" 
                                    DataFormatString="{0:P2}">
									<HeaderStyle Width="12%"></HeaderStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="DepositoryFinancial50" 
                                    
                                    HeaderText="Bank&lt;BR&gt;Financial&lt;BR&gt;Credit/&lt;BR&gt;Liquidity&lt;BR&gt;(50%)^^^^" 
                                    DataFormatString="{0:P2}">
								</asp:BoundColumn>
							    <asp:BoundColumn DataField="LiqNondepFinancial" DataFormatString="{0:P2}" 
                                    HeaderText="Non-Bank&lt;BR&gt;Financial&lt;BR&gt;Liquidity&lt;BR&gt;Facilities&lt;BR&gt;(100%)^^^^^">
                                    <HeaderStyle Width="28%" />
                                </asp:BoundColumn>
							</Columns>
						</asp:datagrid>
					</TD>
					<TD vAlign="top" align="left" width="50%"> 
                        <asp:datagrid id="CCADJGrid" 
                            CssClass="appText" runat="server" AutoGenerateColumns="False"
							Width="100%"  >
					 
							<AlternatingItemStyle HorizontalAlign="Center" CssClass="AlternateTableRow"></AlternatingItemStyle>
							<ItemStyle HorizontalAlign="Center"></ItemStyle>
							<HeaderStyle CssClass="TableHeaderText"></HeaderStyle>
							<Columns>
                                <!-- TPP-8398 -->
								<asp:BoundColumn DataField="Rate1" HeaderText="Line of&lt;BR&gt;Credit Orig.&lt;BR&gt;Maturity&lt;BR&gt;&le;1yr*" DataFormatString="{0:P2}">
									<HeaderStyle Width="17%"></HeaderStyle>
								</asp:BoundColumn>

								<asp:BoundColumn DataField="Rate2" 
                                    HeaderText="Line of&lt;BR&gt;Credit&lt;BR&gt;Orig.&lt;BR&gt;Maturity&lt;BR&gt;>1yr**" DataFormatString="{0:P2}">
									<HeaderStyle Width="17%"></HeaderStyle>
								</asp:BoundColumn>

                                <asp:BoundColumn DataField="Rate3"                                     
                                    HeaderText="Municipal&lt;BR&gt;Gen Ob&lt;BR&gt;***" DataFormatString="{0:P2}">
									<HeaderStyle Width="16%"></HeaderStyle>
								</asp:BoundColumn>

                                <asp:BoundColumn DataField="Rate4"                                     
                                    HeaderText="Municipal&lt;BR&gt;Rev Ob&lt;BR&gt;****" DataFormatString="{0:P2}">
									<HeaderStyle Width="16%"></HeaderStyle>
								</asp:BoundColumn>

								<asp:BoundColumn DataField="Rate5"                                     
                                    HeaderText="Performance&lt;BR&gt;LC&lt;BR&gt;*****" DataFormatString="{0:P2}">
                                    <HeaderStyle Width="16%"></HeaderStyle>
								</asp:BoundColumn>

								<asp:BoundColumn DataField="Rate6"                                     
                                    HeaderText="Financial&lt;BR&gt;LC&lt;BR&gt;******" DataFormatString="{0:P2}">
                                    <HeaderStyle Width="16%"></HeaderStyle>
								</asp:BoundColumn>

							</Columns>
						</asp:datagrid>
					</TD>
				</TR>
			</table>
		</td>
	</TR>
</TABLE>
<TABLE cellSpacing="4" cellPadding="4" width="100%" border="0">
	<asp:panel id="PanelRecsFound2" runat="server" Visible="true">
		<TBODY>
			<TR>
				<TD id="Instructions2">

                
						<div class="appTinyText" id="InstructionsText2" runat="server"/>
					
				</TD>
			</TR>
	</asp:panel><asp:panel id="PanelRecsNF2" runat="server" Visible="false">
		<TR>
			<TD class="appMessage">Rates do not exist for the selected date.
			</TD>
		</TR>
	</asp:panel>
	<TR>
		<TD class="auto-style1" vAlign="top" width="50%"></TD>
	</TR>
	</TBODY>
</TABLE>


