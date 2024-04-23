package com.moass.api.global.auth;

import com.moass.api.domain.user.entity.UserProfile;
import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Getter
public class CustomUserDetails implements UserDetails {
    private UserProfile userProfile;
    private Collection<GrantedAuthority> authorities = new ArrayList<>();

    public CustomUserDetails(UserProfile userProfile) {
        this.userProfile = userProfile;
        initializeAuthorities();
    }

    private void initializeAuthorities() {
        switch (userProfile.getJobCode()) {
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
        return userProfile.getPassword();
    }

    @Override
    public String getUsername() {
        return userProfile.getUserName();
    }

    public String getEmail() {
        return userProfile.getUserEmail();
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
