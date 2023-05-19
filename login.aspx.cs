using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.Management;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        protected void Login(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["project"].ToString();
            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);

            String user = username.Text;
            String pass = password.Text;


            SqlCommand loginproc = new SqlCommand("login", conn); 
            loginproc.CommandType = CommandType.StoredProcedure; 
            loginproc.Parameters.Add(new SqlParameter("@username", user));
            loginproc.Parameters.Add(new SqlParameter("@password", pass));

            SqlParameter type = loginproc.Parameters.Add("@type", SqlDbType.VarChar, 20);
            SqlParameter success = loginproc.Parameters.Add("@success", SqlDbType.Int);

            type.Direction = ParameterDirection.Output;
            success.Direction = ParameterDirection.Output;

            conn.Open();
            loginproc.ExecuteNonQuery();
            conn.Close();

            if(success.Value.ToString()=="1")
            {

                Session["user"] = user;
                

                Response.Write("Hello");
                

                switch(type.Value.ToString())
                {

                    case "association_manager":
                        Response.Redirect("association_manager_dashboard.aspx");
                        break;
                    case "system_admin":
                        Response.Redirect("system_admin_dashboard.aspx");                        
                        break;
                    case "manager":
                        Response.Redirect("manager_dashboard.aspx");
                        break;
                    case "fan":
                        Response.Redirect("fan.aspx");
                        break;
                    case "representative":
                        Response.Redirect("representative_dashboard.aspx");
                        break;
                    default:
                        Response.Write("Nothing");
                        break;
                }

            }
            else  
            {
                if (type.Value.ToString() == "")
                    Response.Write("wrong username or password");
                else
                    Response.Write("you are blocked");
            }

        }

        protected void LinkButton1_Click(object sender, EventArgs e)
        {
            Response.Redirect("registration.aspx");
        }
    }
}