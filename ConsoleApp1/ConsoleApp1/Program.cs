using System;
using System.Data;
using System.Data.SqlClient;

namespace ConsoleApp1
{
    class Program
    {
        static void Main(string[] args)
        {
            const string connectionString = @"Data Source=.\SQLEXPRESS;Initial Catalog=Storage;Integrated Security=True";
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                Console.WriteLine("Подключение открыто");
                var command1 = new SqlCommand("INSERT INTO COMPANY VALUES('123','123')", connection);
                command1.ExecuteNonQuery();
                //var command2 = new SqlCommand("INSERT INTO ITEM VALUES('ZZZZZZZZZZZZZZZZZZZZZZZZZZZ',2)", connection);
                //command2.ExecuteNonQuery();
                //var command3 = new SqlCommand("INSERT INTO STORAGE VALUES(4,777)", connection);
                //command3.ExecuteNonQuery();
                //var command4 = new SqlCommand("UPDATE COMPANY SET Country='00' WHERE COMPANY='AAAAAA'", connection);
                //command3.ExecuteNonQuery();
                //var command5 = new SqlCommand("DELETE FROM STORAGE WHERE Item=3", connection);
                //command3.ExecuteNonQuery();

                SqlDataAdapter adapter = new SqlDataAdapter("SELECT * FROM COMPANY", connection);
                // Создаем объект Dataset
                DataSet ds = new DataSet();
                // Заполняем Dataset
                adapter.Fill(ds);
                foreach (DataTable dt in ds.Tables)
                {
                    foreach (DataColumn column in dt.Columns)
                        Console.Write("\t{0}", column.ColumnName);
                    Console.WriteLine();

                    foreach (DataRow row in dt.Rows)
                    {
                        var cells = row.ItemArray;
                        foreach (object cell in cells)
                            Console.Write("\t{0}", cell);
                        Console.WriteLine();
                    }
                }

            }
            catch (SqlException ex)
            {
                Console.WriteLine(ex.Message);
            }
            finally
            {
                connection.Close();
                Console.WriteLine("Подключение закрыто...");
            }
        }
    }
}
