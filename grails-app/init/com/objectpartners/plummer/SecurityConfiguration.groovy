package com.objectpartners.plummer

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.context.annotation.Configuration
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder
import org.springframework.security.config.annotation.authentication.configurers.provisioning.InMemoryUserDetailsManagerConfigurer
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter

@Configuration
@EnableWebSecurity
class SecurityConfiguration extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        //Enable BASIC auth and prompt for credentials when accessing
        http.authorizeRequests()
                .antMatchers("/**")
                .authenticated()
            .and().httpBasic()
        //Disable CSRF for convenience - do not do this in a production environment!
        http.csrf().disable()
    }

    @Override
    @Autowired
    void configure(AuthenticationManagerBuilder auth) throws Exception {
        InMemoryUserDetailsManagerConfigurer<AuthenticationManagerBuilder> configurer = auth.inMemoryAuthentication();
        //Setup two dummy users - messages are automatically sent to "user" but not "user2"
        configurer.withUser("user").password("password").roles("USER")
        configurer.withUser("user2").password("password").roles("USER")
    }

}
