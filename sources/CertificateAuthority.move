module nikhila_addr::CertificateAuthority {
    use aptos_framework::signer;
    use aptos_framework::timestamp;
    use std::string::{Self, String};
    use std::vector;

    struct Certificate has store, key {
        certificate_id: u64,       
        recipient_name: String,     
        course_name: String,       
        issue_date: u64,           
        issuer: address,           
        is_valid: bool,           
    }
    
    struct CertificateRegistry has store, key {
        next_certificate_id: u64,  
        total_issued: u64,        
    }

    public fun initialize_authority(authority: &signer) {
        let registry = CertificateRegistry {
            next_certificate_id: 1,
            total_issued: 0,
        };
        move_to(authority, registry);
    }

    public fun issue_certificate(
        authority: &signer,
        recipient: address,
        recipient_name: String,
        course_name: String
    ) acquires CertificateRegistry {
        let authority_addr = signer::address_of(authority);
        let registry = borrow_global_mut<CertificateRegistry>(authority_addr);
        
        let certificate = Certificate {
            certificate_id: registry.next_certificate_id,
            recipient_name,
            course_name,
            issue_date: timestamp::now_seconds(),
            issuer: authority_addr,
            is_valid: true,
        };
        
        registry.next_certificate_id = registry.next_certificate_id + 1;
        registry.total_issued = registry.total_issued + 1;
    
        move_to(&create_signer_for_recipient(recipient), certificate);
    }
    
    fun create_signer_for_recipient(recipient: address): signer {
        abort 1
    }

}
