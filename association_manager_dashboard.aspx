<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="association_manager_dashboard.aspx.cs" Inherits="WebApplication1.association_manager_dashboard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            
            <asp:Label ID="Label4" runat="server" Text="Add new Match"></asp:Label>
            <br />
            <asp:TextBox ID="hostClubName" runat="server"></asp:TextBox>
            <asp:TextBox ID="guestClubName" runat="server"></asp:TextBox>
            <asp:TextBox ID="startTime" runat="server" Type="datetime-local"></asp:TextBox>
            <asp:TextBox ID="endTime" runat="server" Type="datetime-local"></asp:TextBox>
            <asp:Button ID="Button1" runat="server" Text="Add Match" OnClick="addNewMatch" />
            <br />
            <asp:Label ID="Label6" runat="server" Text="delete Match"></asp:Label>
            <br />
            <asp:TextBox ID="hostClubName2" runat="server"></asp:TextBox>
            <asp:TextBox ID="guestClubName2" runat="server"></asp:TextBox>
            <asp:TextBox ID="startTime2" runat="server" Type="datetime-local"></asp:TextBox>
            <asp:TextBox ID="endTime2" runat="server" Type="datetime-local"></asp:TextBox>
            <asp:Button ID="Button2" runat="server" Text="Delete Match" OnClick="deleteMatch" />
            <br />
            <asp:Label ID="Label1" runat="server" Text="upcoming matches"></asp:Label>
            <br />
            <asp:GridView ID="GridView1" runat="server">
            </asp:GridView>
            <asp:Label ID="Label2" runat="server" Text="already played matches"></asp:Label>
            <br />
            <asp:GridView ID="GridView2" runat="server">
            </asp:GridView>
            <asp:Label ID="Label3" runat="server" Text="club never scheduled"></asp:Label>
            <br />
            <asp:GridView ID="GridView3" runat="server">
            </asp:GridView>
        </div>
        
    </form>
</body>
</html>
