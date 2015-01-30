package org.jenkinsci.plugins.modernstatus;

import hudson.model.Hudson;

import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class ModernStatusFilter implements Filter {

  final String patternStr = "/(\\d{2}x\\d{2})/%s(_anime|)\\.(gif|png)";
  final String[] names = new String[] {"blue", "red", "yellow", "nobuilt", "aborted", "folder", "grey", "edit-delete", "clock", "disabled"};
  Pattern[] patterns;

  public void init(FilterConfig config) throws ServletException {
    patterns = new Pattern[names.length];
    int i = 0;
    for (String n: names) {
      patterns[i] = Pattern.compile(String.format(patternStr, n));
      i++;
    }
  }

  /**
   * @author Asgeir Storesund Nilsen
   */
  public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {
    if (req instanceof HttpServletRequest && resp instanceof HttpServletResponse) {
      final HttpServletRequest httpServletRequest = (HttpServletRequest) req;
      final HttpServletResponse httpServletResponse = (HttpServletResponse) resp;
      final String uri = httpServletRequest.getRequestURI();
      if (uri.endsWith(".gif") || uri.endsWith(".png")) {
        String newImageUrl = mapImage(uri);
        if (newImageUrl != null) {
          RequestDispatcher dispatcher = httpServletRequest.getRequestDispatcher(newImageUrl);
          dispatcher.forward(httpServletRequest, httpServletResponse);
          return;
        }
      }
    }
    chain.doFilter(req, resp);
  }

  /**
   * Original
   * @author Asgeir Storesund Nilsen
   * Simplified
   * @author Oliver Vinn
   */
  private String mapImage(String uri) {
    if (!uri.contains("plugin/modernstatus/")) {
        Matcher m;
        for (int i=0; i < patterns.length; i++) {
            if ((m = patterns[i].matcher(uri)).find()) {
                return "/plugin/modernstatus/" + m.group(1) + "/" + names[i] + m.group(2) + "." + m.group(3);
            }
        }
    }
    return null;
  }

  public void destroy() {
  }
}
