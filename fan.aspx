<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="fan.aspx.cs" Inherits="WebApplication1.fan" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            Enter Date
            <br />
            <asp:TextBox ID="date1" runat="server" type="date"></asp:TextBox>
            <asp:Button ID="Button1" runat="server" OnClick="ViewMatches" Text="Enter" />
            <br />
            <asp:Label ID="Label1" runat="server" Text="available matches"></asp:Label>
   
            <asp:GridView ID="GridView1" runat="server">
            </asp:GridView>
        <p>PURCHASE A TICKET</p>
        Hosting Club Name<br />
        <asp:TextBox ID="hostreg" runat="server"></asp:TextBox>
        <br />
        Guest Club Name<br />
        <asp:TextBox ID="guestreg" runat="server" ></asp:TextBox>
        <br />
        Date of the Match<br />
        <asp:TextBox ID="datereg" runat="server" type="datetime-local"></asp:TextBox>
        <br />
        <br />
        <asp:Button ID="Purchase1" runat="server" OnClick="Purchase" Text="Purchase" />
        </div>
        
    </form>
</body>
</html>
