package pfoxit.carhub;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
class RootController {

    @GetMapping("/")
    public String index() {
        return "Welcome to CarHub!";
    }
}
