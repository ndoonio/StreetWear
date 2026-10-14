package streetwear.config;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import org.apache.tomcat.jdbc.pool.DataSource;
import org.apache.tomcat.jdbc.pool.PoolProperties;

/*
 * DataSourceListener viene eseguito automaticamente quando Tomcat avvia il progetto.
 *
 * Serve per creare il DataSource, cioè l'oggetto che permette alle Servlet
 * e ai DAO di collegarsi al database.
 */
@WebListener
public class DataSourceListener implements ServletContextListener {

    private DataSource dataSource;

    @Override
    public void contextInitialized(ServletContextEvent event) {

        PoolProperties properties = new PoolProperties();

        properties.setUrl(
        	    "jdbc:mysql://localhost:3306/streetwear?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true"
        );

        /*
         * Driver MySQL.
         */
        properties.setDriverClassName("com.mysql.cj.jdbc.Driver");

        /*
         * Con XAMPP di solito:
         * username = root
         * password = vuota
         */
        properties.setUsername("root");
        properties.setPassword("");

        /*
         * Impostazioni base del pool di connessioni.
         */
        properties.setInitialSize(2);
        properties.setMaxActive(10);
        properties.setMaxIdle(5);
        properties.setMinIdle(1);

        /*
         * Creo il DataSource.
         */
        dataSource = new DataSource();
        dataSource.setPoolProperties(properties);

        /*
         * Salvo il DataSource nel ServletContext.
         * Le Servlet lo recuperano con:
         *
         * getServletContext().getAttribute("DataSource")
         */
        event.getServletContext().setAttribute("DataSource", dataSource);

        System.out.println("DataSource creato correttamente.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent event) {

        if (dataSource != null) {
            dataSource.close();
        }

        System.out.println("DataSource chiuso.");
    }
}