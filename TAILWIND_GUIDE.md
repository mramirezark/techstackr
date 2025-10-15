# 🎨 Tailwind CSS Guide

TechStackr now uses Tailwind CSS for modern, utility-first styling!

## ✅ Installation Complete

### What's Been Installed

- **tailwindcss-rails** gem (v4.3.0)
- **Tailwind CSS** v4.1.13
- Custom utility classes for consistency
- Build process configured

## 🚀 Getting Started

### Running the Development Server

**Option 1: With Tailwind Watch (Recommended)**
```bash
bin/dev
```
This starts:
- Rails server on port 3000
- Tailwind CSS watcher (auto-rebuilds on changes)

**Option 2: Without Tailwind Watch**
```bash
bundle exec rails server
# CSS won't auto-rebuild, run manually: rails tailwindcss:build
```

### Building Tailwind CSS

```bash
# Build once
rails tailwindcss:build

# Watch for changes (auto-rebuild)
rails tailwindcss:watch

# Build for production
rails tailwindcss:build
```

## 🎨 Custom Utility Classes

Pre-configured utility classes for consistency:

### Buttons
```html
<button class="btn btn-primary">Primary Button</button>
<button class="btn btn-success">Success Button</button>
<button class="btn btn-danger">Danger Button</button>
<button class="btn btn-secondary">Secondary Button</button>
```

**Styles:**
- `.btn` - Base button styles (padding, rounded, transitions)
- `.btn-primary` - Blue button
- `.btn-success` - Green button
- `.btn-danger` - Red button
- `.btn-secondary` - Gray button

### Cards
```html
<div class="card">
  <!-- Card content -->
</div>
```

**Styles:** White background, rounded corners, shadow, padding

### Badges
```html
<span class="badge badge-primary">Primary</span>
<span class="badge badge-success">Success</span>
<span class="badge badge-warning">Warning</span>
<span class="badge badge-danger">Danger</span>
```

**Styles:** Rounded pill shape, colored backgrounds

## 💡 Using Tailwind Classes

### Layout Example

```erb
<div class="container mx-auto px-4 py-6">
  <h1 class="text-3xl font-bold text-gray-900 mb-4">
    Welcome to TechStackr
  </h1>
  
  <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
    <div class="bg-white rounded-lg shadow-md p-6">
      <h2 class="text-xl font-semibold mb-2">Card Title</h2>
      <p class="text-gray-600">Card content...</p>
    </div>
  </div>
</div>
```

### Common Patterns

**Flex Layouts:**
```html
<div class="flex items-center justify-between">
  <h1>Left</h1>
  <button>Right</button>
</div>
```

**Spacing:**
```html
<div class="p-4">Padding all sides</div>
<div class="px-6 py-4">Horizontal & vertical padding</div>
<div class="mt-4 mb-6">Margins</div>
```

**Colors:**
```html
<div class="bg-blue-500 text-white">Blue background</div>
<div class="text-gray-600">Gray text</div>
<div class="border border-gray-300">Border</div>
```

**Typography:**
```html
<h1 class="text-4xl font-bold">Large Heading</h1>
<p class="text-lg text-gray-700">Paragraph</p>
<span class="text-sm font-medium">Small text</span>
```

**Responsive:**
```html
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4">
  <!-- 1 col on mobile, 2 on tablet, 4 on desktop -->
</div>
```

## 🔄 Migration Strategy

### Gradual Migration

You can migrate from inline styles to Tailwind gradually:

1. **Keep existing styles** - Current inline styles still work
2. **Add Tailwind to new components** - Use Tailwind for new views
3. **Refactor incrementally** - Convert existing views one at a time

### Example: Before & After

**Before (Inline Styles):**
```erb
<div style="background-color: white; padding: 20px; border-radius: 8px;">
  <h1 style="font-size: 24px; font-weight: bold;">Title</h1>
</div>
```

**After (Tailwind):**
```erb
<div class="bg-white p-5 rounded-lg">
  <h1 class="text-2xl font-bold">Title</h1>
</div>
```

## 📁 File Structure

```
app/assets/
├── tailwind/
│   └── application.css       # Tailwind config & custom utilities
├── builds/
│   └── tailwind.css          # Generated CSS (gitignored)
├── config/
│   └── manifest.js           # Asset pipeline manifest
```

## 🎨 Customization

### Adding Custom Colors

Edit `app/assets/tailwind/application.css`:

```css
@import "tailwindcss";

@layer theme {
  --color-primary: #3498db;
  --color-secondary: #2ecc71;
}
```

### Adding Custom Components

```css
@layer components {
  .project-card {
    @apply bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition-shadow;
  }
  
  .status-badge {
    @apply inline-block px-3 py-1 rounded-full text-sm font-semibold;
  }
}
```

## 🔧 Configuration

### Procfile.dev

The development process is managed by Foreman:

```yaml
web: bin/rails server
css: bin/rails tailwindcss:watch
```

This runs both servers simultaneously:
- Rails on port 3000
- Tailwind watcher (auto-rebuilds on changes)

### Asset Pipeline

Tailwind CSS is integrated with the asset pipeline:

```ruby
# app/assets/config/manifest.js
//= link tailwind.css
//= link_tree ../images
//= link_tree ../builds
```

## 🛠️ Development Workflow

### Starting Development

```bash
# Recommended: Run with Tailwind watch
bin/dev

# Visit: http://localhost:3000
```

### Making Style Changes

1. Edit your `.html.erb` files with Tailwind classes
2. Save the file
3. Tailwind automatically rebuilds (if using `bin/dev`)
4. Refresh browser to see changes

### Production Deployment

```bash
# Build optimized Tailwind CSS
rails tailwindcss:build

# Precompile all assets
rails assets:precompile
```

## 📊 Current Status

### ✅ Installed & Configured

- Tailwind CSS v4.1.13
- Custom utility classes (btn, card, badge)
- Build process configured
- Development server setup (Procfile.dev)

### 📝 Next Steps

You can now:

1. **Keep current styles** - Inline styles still work
2. **Start using Tailwind** - Add classes to new views
3. **Gradually migrate** - Convert existing views over time

### 🎯 Recommended Approach

**New Views:** Use Tailwind classes exclusively
**Existing Views:** Migrate incrementally as you make updates

## 📚 Resources

- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [Tailwind CSS Rails Guide](https://github.com/rails/tailwindcss-rails)
- [Tailwind CSS Cheat Sheet](https://nerdcave.com/tailwind-cheat-sheet)

## 💡 Quick Reference

### Common Classes

| Purpose | Classes |
|---------|---------|
| **Container** | `container mx-auto px-4` |
| **Flex Row** | `flex items-center justify-between` |
| **Grid** | `grid grid-cols-3 gap-4` |
| **Card** | `bg-white rounded-lg shadow-md p-6` |
| **Button** | `btn btn-primary` or `bg-blue-600 text-white px-4 py-2 rounded` |
| **Text** | `text-lg font-bold text-gray-900` |
| **Spacing** | `p-4 m-4 mt-2 mb-6 px-4 py-2` |
| **Colors** | `bg-blue-500 text-white border-gray-300` |

### Responsive Design

```html
<!-- Mobile first approach -->
<div class="text-sm md:text-base lg:text-lg">
  Responsive text size
</div>

<!-- Breakpoints: sm (640px), md (768px), lg (1024px), xl (1280px) -->
```

## 🎉 Benefits

With Tailwind CSS, you get:

✅ **Utility-First** - No more writing custom CSS
✅ **Responsive** - Built-in responsive design utilities
✅ **Consistent** - Predefined design system
✅ **Fast Development** - Rapid prototyping
✅ **Small Bundle** - Only includes used classes
✅ **Modern** - Latest CSS features

## ⚠️ Important Notes

1. **Run `bin/dev`** for development (not `rails server`)
2. **Tailwind builds** are in `app/assets/builds/` (gitignored)
3. **Custom utilities** are in `app/assets/tailwind/application.css`
4. **Mix with inline styles** - Can use both during migration

---

**Start developing with Tailwind CSS:**
```bash
bin/dev
```

Visit: http://localhost:3000 and start building! 🎨✨

