<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="system_admin_dashboard.aspx.cs" Inherits="project.system_admin_dashboard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="Label6" runat="server" Text="Add new Club"></asp:Label>
            <br />
            name:

            <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;location:
            <asp:TextBox ID="TextBox2" runat="server"></asp:TextBox>
            <br />
            <asp:Label ID="Label1" runat="server" Text=""></asp:Label>
            <br />
            <asp:Button ID="Button1" runat="server" Text="add club" OnClick="Button1_Click" />
            <br />
            <asp:Label ID="Label7" runat="server" Text="Label"></asp:Label>
            <br />
            <asp:Label ID="Label9" runat="server" Text="Delete Club"></asp:Label>
            <br />
            name:<asp:TextBox ID="TextBox3" runat="server"></asp:TextBox>
            <br />
            <asp:Label ID="Label2" runat="server" Text=""></asp:Label>
            <br />
            <asp:Button ID="Button2" runat="server" Text="delete club" OnClick="Button2_Click" />
            <br />
            <asp:Label ID="Label8" runat="server" Text="Label"></asp:Label>
            <br />
            <asp:Label ID="Label12" runat="server" Text="Add new Stadium"></asp:Label>
            <br />
            name: <asp:TextBox ID="TextBox4" runat="server"></asp:TextBox>
&nbsp;&nbsp;&nbsp;
            <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <br />
            location:
            <asp:TextBox ID="TextBox5" runat="server"></asp:TextBox>
            <br />
            <br />
            capacity:
            <asp:TextBox ID="TextBox6" runat="server"></asp:TextBox>
            <br />
            <asp:Label ID="Label3" runat="server" Text=""></asp:Label>
            <br />
            <asp:Button ID="Button3" runat="server" Text="Add stadium" OnClick="Button3_Click" />
            <br />
            <br />
            <asp:Label ID="Label10" runat="server" Text="delete Stadium"></asp:Label>
            <br />
            name:<asp:TextBox ID="TextBox7" runat="server"></asp:TextBox>
            <br />
            <asp:Label ID="Label4" runat="server" Text=""></asp:Label>
            <br />
            <asp:Button ID="Button4" runat="server" Text="Delete stadium" OnClick="Button4_Click" />
            <br />
            <br />
            <asp:Label ID="Label11" runat="server" Text="Block Fan"></asp:Label>
            <br />
            national id:<asp:TextBox ID="TextBox8" runat="server"></asp:TextBox>
            <br />
            <asp:Label ID="Label5" runat="server" Text=""></asp:Label>
            <br />
            <asp:Button ID="Button5" runat="server" Text="Block fan" OnClick="Button5_Click" />
            <br />
        </div>
    </form>
</body>
</html>
