<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="representative_dashboard.aspx.cs" Inherits="project.representative_dashboard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>

            club you are representing:<br />
            <br />

            <asp:GridView ID="GridView1" runat="server" OnSelectedIndexChanged="GridView1_SelectedIndexChanged">
            </asp:GridView>
            <br />
            upcoming matches of your club:<br />
            <br />
            <asp:GridView ID="GridView2" runat="server" OnSelectedIndexChanged="GridView2_SelectedIndexChanged">
            </asp:GridView>
            <br />
            <br />
            date:
            <asp:TextBox ID="TextBox1" runat="server" type= "date" OnTextChanged="TextBox1_TextChanged"></asp:TextBox>
            <br />
            <br />
            <asp:Button ID="Button1" runat="server" Text="View Available Stadiums" OnClick="Button1_Click" />
            <br />
            <br />
            <asp:GridView ID="GridView3" runat="server" OnSelectedIndexChanged="GridView3_SelectedIndexChanged">
            </asp:GridView>
            <br />
            stadium name: <asp:TextBox ID="TextBox2" runat="server"></asp:TextBox>
            <br />
            <br />
            date of match:
            <asp:TextBox ID="TextBox3" type="datetime-local" runat="server"></asp:TextBox>
            <br />
            <asp:Label ID="Label1" runat="server" Text=""></asp:Label>
            <br />
            <asp:Button ID="Button2" runat="server" Text="Send Request" OnClick="Button2_Click" />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />

        </div>
    </form>
</body>
</html>