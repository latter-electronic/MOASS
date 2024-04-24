package com.moass.api.global.auth;

import com.moass.api.domain.user.entity.UserDetail;
import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.ArrayList;
import java.util.Collection;

@Getter
public class CustomUserDetails implements UserDetails {
    private UserDetail userDetail;
    private Collection<GrantedAuthority> authorities = new ArrayList<>();

    public CustomUserDetails(UserDetail userDetail) {
        this.userDetail = userDetail;
        initializeAuthorities();
    }

    private void initializeAuthorities() {
        switch (userDetail.getJobCode()) {
            case 1:
                authorities.add(() -> "ROLE_STUDENT");
                break;
            case 2:
                authorities.add(() -> "ROLE_COACH");
                break;
            case 3:
                authorities.add(() -> "ROLE_CONSULTANT");
                break;
            case 4:
                authorities.add(() -> "ROLE_ADMIN");
                break;
        }
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    @Override
    public String getPassword() {
        return userDetail.getPassword();
    }

    @Override
    public String getUsername() {
        return userDetail.getUserName();
    }

    public String getEmail() {
        return userDetail.getUserEmail();
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}
