/**
 * 笔记阅读端 · 轮播渲染器
 * 用法：
 *   <script src="./carousel-renderer.js"></script>
 *   <script>NoteCarouselInit();</script>
 *
 * 期望 HTML 结构（由 note-editor.html 的 mdToHtml 生成）：
 *   <div class="carousel-render" data-idx="0">
 *     <div class="counter">1 / N</div>
 *     <div class="track">
 *       <div class="slide">
 *         <img src="..." alt="...">
 *         <div class="intro"><b>标题</b>介绍文字</div>  <!-- 可选 -->
 *       </div>
 *       ...
 *     </div>
 *     <button class="arrow prev">‹</button>
 *     <button class="arrow next">›</button>
 *     <div class="dots">
 *       <button class="dot active" data-idx="0"></button>
 *       ...
 *     </div>
 *   </div>
 *
 * 本文件依赖元素已经由 mdToHtml() 注入到正文，无需用户自己拼 DOM。
 * 它只负责赋予"行为"：切换、自动播放、手势。
 */
(function () {
  function initOne(el) {
    if (el.__inited) return;
    el.__inited = true;
    const track  = el.querySelector('.track');
    const slides = el.querySelectorAll('.slide');
    const dots   = el.querySelectorAll('.dot');
    const prev   = el.querySelector('.arrow.prev');
    const next   = el.querySelector('.arrow.next');
    const counter = el.querySelector('.counter');
    const total  = slides.length;
    if (total <= 0) return;

    let idx = 0;
    let autoplay = null;
    const INTERVAL = 4500;

    function show(i) {
      idx = (i + total) % total;
      track.style.transform = `translateX(-${idx * 100}%)`;
      dots.forEach((d, j) => d.classList.toggle('active', j === idx));
      if (counter) counter.textContent = `${idx + 1} / ${total}`;
    }
    function start() {
      stop();
      if (total > 1) autoplay = setInterval(() => show(idx + 1), INTERVAL);
    }
    function stop() {
      if (autoplay) { clearInterval(autoplay); autoplay = null; }
    }

    prev && (prev.onclick = () => { show(idx - 1); start(); });
    next && (next.onclick = () => { show(idx + 1); start(); });
    dots.forEach(d => d.onclick = () => { show(+d.dataset.idx); start(); });

    el.addEventListener('mouseenter', stop);
    el.addEventListener('mouseleave', start);
    el.addEventListener('click', e => {
      if (e.target.closest('.arrow') || e.target.closest('.dot')) return;
      show(idx + 1); start();
    });

    // 手势
    let sx = 0, dx = 0, dragging = false;
    el.addEventListener('touchstart', e => { sx = e.touches[0].clientX; dragging = true; stop(); }, { passive: true });
    el.addEventListener('touchmove',  e => { if (!dragging) return; dx = e.touches[0].clientX - sx; }, { passive: true });
    el.addEventListener('touchend',   () => {
      if (!dragging) return;
      dragging = false;
      if (Math.abs(dx) > 50) show(idx + (dx < 0 ? 1 : -1));
      dx = 0;
      start();
    });

    // 关键帧可见才加载图片
    if ('IntersectionObserver' in window) {
      const io = new IntersectionObserver(entries => {
        entries.forEach(e => {
          if (e.isIntersecting) {
            const img = e.target.querySelector('img');
            if (img && img.dataset.src) { img.src = img.dataset.src; delete img.dataset.src; }
          }
        });
      }, { root: el, threshold: 0.5 });
      slides.forEach(s => io.observe(s));
    }

    show(0);
    start();
  }

  function initAll(scope) {
    (scope || document).querySelectorAll('.carousel-render').forEach(initOne);
  }

  // DOM 就绪后自动跑一遍
  function ready(fn) {
    if (document.readyState !== 'loading') fn();
    else document.addEventListener('DOMContentLoaded', fn);
  }

  ready(() => {
    initAll();
    // 兼容后续动态插入
    const mo = new MutationObserver(muts => {
      muts.forEach(m => m.addedNodes.forEach(n => {
        if (n.nodeType === 1) {
          if (n.matches && n.matches('.carousel-render')) initOne(n);
          else initAll(n);
        }
      }));
    });
    mo.observe(document.body, { childList: true, subtree: true });
  });

  window.NoteCarouselInit = function (scope) { initAll(scope); };
  window.NoteCarousel = { initAll, initOne };
})();
