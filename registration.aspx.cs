using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace project
{
    public partial class registration : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
            DropDownList1.AutoPostBack = true;
            switch (DropDownList1.SelectedIndex)
            {
                case 1:
                    TextBox4.Visible = true;
                    TextBox5.Visible = true;
                    TextBox6.Visible = true;
                    TextBox7.Visible = true;
                    Button1.Visible = true;
                    Label1.Text = "national id number";
                    Label2.Text = "phone number";
                    Label3.Text = "birth date";
                    Label4.Text = "address";
                    break;
                case 2:
                    TextBox4.Visible = true;
                    TextBox5.Visible = false;
                    TextBox6.Visible = false;
                    TextBox7.Visible = false;
                    Button1.Visible = true;
                    Label1.Text = "name of club you are representing";
                    Label2.Text = "";
                    Label3.Text = "";
                    Label4.Text = "";
                    break;
                case 3:
                    TextBox4.Visible = false;
                    TextBox5.Visible = false;
                    TextBox6.Visible = false;
                    TextBox7.Visible = false;
                    Button1.Visible = true;
                    Label1.Text = "";
                    Label2.Text = "";
                    Label3.Text = "";
                    Label4.Text = "";
                    break;
                case 4:
                    TextBox4.Visible = true;
                    TextBox5.Visible = false;
                    TextBox6.Visible = false;
                    TextBox7.Visible = false;
                    Button1.Visible = true;
                    Label1.Text = "name of stadium you are managing";
                    Label2.Text = "";
                    Label3.Text = "";
                    Label4.Text = "";
                    break;
                default:
                    TextBox4.Visible = false;
                    TextBox5.Visible = false;
                    TextBox6.Visible = false;
                    TextBox7.Visible = false;
                    Button1.Visible = false;
                    Label1.Text = "";
                    Label2.Text = "";
                    Label3.Text = "";
                    Label4.Text = "";
                    break;
            }

        }

        protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
        {
            
            switch (DropDownList1.SelectedIndex)
            {
                case 1:
                    TextBox4.Visible = true;
                    TextBox5.Visible = true;
                    TextBox6.Visible = true;
                    TextBox7.Visible = true;
                    Button1.Visible = true;
                    Label1.Text = "national id number";
                    Label2.Text = "phone number";
                    Label3.Text = "birth date";
                    Label4.Text = "address";
                    break;
                case 2:
                    TextBox4.Visible = true;
                    TextBox5.Visible = false;
                    TextBox6.Visible = false;
                    TextBox7.Visible = false;
                    Button1.Visible = true;
                    Label1.Text = "name of club you are representing";
                    Label2.Text = "";
                    Label3.Text = "";
                    Label4.Text = "";
                    break;
                case 3:
                    TextBox4.Visible = false;
                    TextBox5.Visible = false;
                    TextBox6.Visible = false;
                    TextBox7.Visible = false;
                    Button1.Visible = true;
                    Label1.Text = "";
                    Label2.Text = "";
                    Label3.Text = "";
                    Label4.Text = "";
                    break;
                case 4:
                    TextBox4.Visible = true;
                    TextBox5.Visible = false;
                    TextBox6.Visible = false;
                    TextBox7.Visible = false;
                    Button1.Visible = true;
                    Label1.Text = "name of stadium you are managing";
                    Label2.Text = "";
                    Label3.Text = "";
                    Label4.Text = "";
                    break;
                default:
                    TextBox4.Visible = false;
                    TextBox5.Visible = false;
                    TextBox6.Visible = false;
                    TextBox7.Visible = false;
                    Button1.Visible = false;
                    Label1.Text = "";
                    Label2.Text = "";
                    Label3.Text = "";
                    Label4.Text = "";
                    break;
            }
        }
        protected void Button1_Click1(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["project"].ToString();
            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);



            conn.Open();

            String successOut = "1";
            String errorOut = "";
            String name = TextBox1.Text;
            String user = TextBox2.Text;
            if (name == "")
            {
                errorOut = errorOut + "\n enter name";
                successOut = "0";
            }
            if (user == "")
            {
                errorOut = errorOut + "\n enter username";
                successOut = "0";
            }
            String pass = TextBox3.Text;
            String commontextbox = TextBox4.Text;
            if (successOut == "1")
            {
                switch (DropDownList1.SelectedIndex)
                {
                    case 1:

                        SqlCommand addFanProc = new SqlCommand("addFanProc", conn);
                        addFanProc.CommandType = CommandType.StoredProcedure;


                        String phoneNo = TextBox5.Text;
                        String birthdate = DateTime.Now.ToString(TextBox6.Text);
                        String address = TextBox7.Text;

                        if (address == "")
                        {
                            errorOut = errorOut + "\n enter address"; 
                            successOut = "0";
                        }
                        if (successOut == "1")
                        {
                            addFanProc.Parameters.AddWithValue("@name", name);
                            addFanProc.Parameters.AddWithValue("@username", user);
                            addFanProc.Parameters.AddWithValue("@password", pass);
                            addFanProc.Parameters.AddWithValue("@nationalid", commontextbox);
                            addFanProc.Parameters.AddWithValue("@birthdate", birthdate);
                            addFanProc.Parameters.AddWithValue("@address", address);
                            addFanProc.Parameters.AddWithValue("@phone", phoneNo);


                            SqlParameter success1 = addFanProc.Parameters.Add("@success", SqlDbType.Int);
                            success1.Direction = ParameterDirection.Output;
                            SqlParameter error1 = addFanProc.Parameters.Add("@error", SqlDbType.VarChar, 200);
                            error1.Direction = ParameterDirection.Output;
                            addFanProc.ExecuteNonQuery();

                            successOut = success1.Value.ToString();
                            errorOut = error1.Value.ToString();
                        }

                        break;
                    case 2:

                        SqlCommand addRepresentativeProc = new SqlCommand("addRepresentativeProc", conn);
                        addRepresentativeProc.CommandType = CommandType.StoredProcedure;




                        addRepresentativeProc.Parameters.AddWithValue("@name", name);
                        addRepresentativeProc.Parameters.AddWithValue("@username", user);
                        addRepresentativeProc.Parameters.AddWithValue("@password", pass);
                        addRepresentativeProc.Parameters.AddWithValue("@Clubname", commontextbox);

                        SqlParameter success2 = addRepresentativeProc.Parameters.Add("@success", SqlDbType.Int);
                        success2.Direction = ParameterDirection.Output;
                        SqlParameter error2 = addRepresentativeProc.Parameters.Add("@error", SqlDbType.VarChar, 200);
                        error2.Direction = ParameterDirection.Output;
                        addRepresentativeProc.ExecuteNonQuery();

                        successOut = success2.Value.ToString();
                        errorOut = error2.Value.ToString();

                        break;
                    case 3:

                        SqlCommand addAssociationManagerProc = new SqlCommand("addAssociationManagerProc", conn);
                        addAssociationManagerProc.CommandType = CommandType.StoredProcedure;

                        addAssociationManagerProc.Parameters.AddWithValue("@name", name);
                        addAssociationManagerProc.Parameters.AddWithValue("@username", user);
                        addAssociationManagerProc.Parameters.AddWithValue("@password", pass);

                        SqlParameter success3 = addAssociationManagerProc.Parameters.Add("@success", SqlDbType.Int);
                        success3.Direction = ParameterDirection.Output;
                        SqlParameter error3 = addAssociationManagerProc.Parameters.Add("@error", SqlDbType.VarChar, 200);
                        error3.Direction = ParameterDirection.Output;
                        addAssociationManagerProc.ExecuteNonQuery();

                        successOut = success3.Value.ToString();
                        errorOut = error3.Value.ToString();
                        break;
                    case 4:

                        SqlCommand addStadiumManagerProc = new SqlCommand("addStadiumManagerProc", conn);
                        addStadiumManagerProc.CommandType = CommandType.StoredProcedure;

                        addStadiumManagerProc.Parameters.AddWithValue("@name", name);
                        addStadiumManagerProc.Parameters.AddWithValue("@username", user);
                        addStadiumManagerProc.Parameters.AddWithValue("@password", pass);
                        addStadiumManagerProc.Parameters.AddWithValue("@stadium_name", commontextbox);

                        SqlParameter success4 = addStadiumManagerProc.Parameters.Add("@success", SqlDbType.Int);
                        success4.Direction = ParameterDirection.Output;
                        SqlParameter error4 = addStadiumManagerProc.Parameters.Add("@error", SqlDbType.VarChar, 200);
                        error4.Direction = ParameterDirection.Output;
                        addStadiumManagerProc.ExecuteNonQuery();

                        successOut = success4.Value.ToString();
                        errorOut = error4.Value.ToString();
                        break;
                    default:
                        break;
                }
            }


            if (successOut == "1")
            {
                Response.Write("registeration successful");
                Response.Redirect("login.aspx");
            }
            else
            {
                Response.Write(errorOut);
            }
        }

    }
}