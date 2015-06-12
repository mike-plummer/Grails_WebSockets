package com.objectpartners.plummer

import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity
import org.springframework.context.annotation.Configuration

@Configuration
@EnableWebSecurity
class SecurityConfiguration extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        //Enable BASIC auth and prompt for credentials when accessing /secure.gsp
        http.httpBasic().and().authorizeRequests().antMatchers("/secure").authenticated()
        //Disable CSRF for convenience - do not do this in a production environment!
        http.csrf().disable()
    }

    @Autowired
    void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
        //Setup two dummy users - messages are automatically sent to "user" but not "user2"
        auth.inMemoryAuthentication().withUser("user").password("password").roles("USER")
        auth.inMemoryAuthentication().withUser("user2").password("password").roles("USER")
    }

}
