<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="manager_dashboard.aspx.cs" Inherits="WebApplication1.manager_dashboard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="Label1" runat="server" Text="My Stadium"></asp:Label>
            <br />
            <asp:GridView ID="GridView1" runat="server">
            </asp:GridView>
             <asp:Label ID="Label2" runat="server" Text="Requests to Me"></asp:Label>
            <br />
            <asp:GridView ID="GridView2" runat="server" OnRowCommand="GridView2_RowCommand" >
                <Columns>
                    <asp:ButtonField ButtonType="Button" CommandName="accept" HeaderText="Accept?" ShowHeader="True" Text="Accept" />
                    <asp:ButtonField ButtonType="Button" CommandName="reject" HeaderText="Reject?" ShowHeader="True" Text="Reject" />
                </Columns>
            </asp:GridView>
            
        </div>
    </form>
</body>
</html>
