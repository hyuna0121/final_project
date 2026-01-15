package com.cafe.erp.security;

import java.util.Collection;
import java.util.Objects;

import com.cafe.erp.store.StoreDTO;
import jakarta.mail.Store;
import lombok.Getter;
import lombok.ToString;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import com.cafe.erp.member.MemberDTO;

@Getter
@ToString
public class UserDTO implements UserDetails {

	private MemberDTO member;
	private StoreDTO store;
	private Collection<? extends GrantedAuthority> authorities;

	public UserDTO(MemberDTO memberDTO, StoreDTO store, Collection<? extends GrantedAuthority> authorities) {
		this.member = memberDTO;
		this.store = store;
		this.authorities = authorities;
	}

	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() { return this.authorities; }

	@Override
	public String getPassword() {
		return member.getMemPassword();
	}

	@Override
	public String getUsername() {
		return String.valueOf(member.getMemberId());
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj) return true;
		if (obj == null) return false;
		if (getClass() != obj.getClass()) return false;
		UserDTO other = (UserDTO) obj;
		return this.member.getMemberId() == other.member.getMemberId();
	}

	@Override
	public int hashCode() {
		return Objects.hash(this.member.getMemberId());
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
