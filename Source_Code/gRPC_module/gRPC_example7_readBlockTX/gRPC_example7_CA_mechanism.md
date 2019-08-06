## 1. Certificate Authority (CA)

**Question 1.1:** what is certificate authority? 

Certificate-based Authentication. For example, in practice, we have X.509 Certificate based Authentication.



**Question 1.2:** why we need certificate-based authentication? or what is the motivation of authentication?

In a nutshell, "authentication" is the process of verifying that a user is who tthey say they are. For example, Alice says she is Alice but Bob does not trust it. Alice and Bob need to find a trusted third party. If Alice successfully get a digital certificate which includes Alice name from the trusted third party. Then Bob can verify that whether Alice's digital certificate is issued by the third party or not. If yes, Bob can verify that Alice is the Alice, based on the assumption of trusted third party and the security of asymmetric cryptography.     

If there are no trusted third party to issue digital certificates, or asymmetric cryptography is not secure, then the assumption does not hold. It is beyond our discussion.




**Question 1.3:** how digital certificate chain verified based on asymmetric cryptography?





